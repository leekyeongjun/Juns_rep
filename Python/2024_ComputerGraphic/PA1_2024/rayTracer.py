#!/usr/bin/env python3
# -*- coding: utf-8 -*
# sample_python aims to allow seamless integration with lua.
# see examples below
import os
import sys
import pdb  # use pdb.set_trace() for debugging
import code # or use code.interact(local=dict(globals(), **locals()))  for debugging.
import xml.etree.ElementTree as ET
import numpy as np
from PIL import Image 

class Color:
    def __init__(self, R, G, B):
        self.color=np.array([R,G,B]).astype(np.float64)
    def gammaCorrect(self, gamma):
        inverseGamma = 1.0 / gamma
        self.color=np.power(self.color, inverseGamma)
    def toUINT8(self):
        return (np.clip(self.color, 0,1)*255).astype(np.uint8)
    
class Shader:
    def __init__(self, type, name, diffuseColor, specularColor=None, exponent=None):
        self.name = name
        self.type = type
        self.diffuseColor = diffuseColor
        if self.type == "Phong":
            self.specularColor = np.array(specularColor.split()).astype(np.float64)
            self.exponent = np.array(exponent.split()).astype(np.float64)[0]


class Shape:
    def __init__(self, surfacetype, radius, center, shader):
        self.radius = radius
        self.type = surfacetype
        self.center = center
        self.shader = shader

class Light:
    def __init__(self, position, intensity):
        self.position = position
        self.intensity = intensity

class Camera:
    def __init__(self, viewPoint, viewDir, viewUp, viewWidth, viewHeight, viewProjDistance = None, viewProjNormal = None):
        self.viewPoint = viewPoint
        self.viewDir = viewDir
        self.viewUp = viewUp
        self.viewWidth = viewWidth
        self.viewHeight = viewHeight
        self.viewProjDistance = viewProjDistance
        self.viewProjNormal = viewProjNormal


def Raytrace(ray, viewPoint, shapes, index, lights):
    myshape = shapes[index]
    n = np.array([0,0,0])

    if myshape.type == "Sphere":
        n = viewPoint + ray - myshape.center
        n = n / np.linalg.norm(n)

    r=0
    g=0
    b=0

    for light in lights:
        lightvec = - ray + light.position-viewPoint
        lightvec = lightvec / np.sqrt(np.sum(lightvec * lightvec))
        l_index = -1
        mv = np.finfo(np.float64).max

        for shape in shapes:
            ll = np.sum((-lightvec) * (-lightvec))
            ld = np.sum((light.position - shape.center) * (-lightvec))
            ldr2 = np.sum((light.position - shape.center)**2) - shape.radius**2
            a = ld**2-ll*ldr2

            if a >= 0:
                w= np.sqrt(a)
                s= -ld+w
                t= -ld-w
                if (s >= 0) :
                    if (mv >= s / ll) :
                        mv = s / ll
                        l_index = shapes.index(shape)
                    if (mv >= t / ll) :
                        mv = t / ll
                        l_index = shapes.index(shape)

        intesity=light.intensity

        if l_index == index:
            red, green, blue = myshape.shader.diffuseColor
            dif = max(0, np.dot(lightvec, n))
            r += red * intesity[0] * dif
            g += green * intesity[1] * dif
            b += blue * intesity[2] * dif

            if myshape.shader.type == "Phong":
                if myshape.shader.specularColor is not None:
                    nv = (-ray) / np.linalg.norm((-ray))
                    h = (nv + lightvec) / np.linalg.norm(nv + lightvec)
                    spec = np.power(np.maximum(0, np.dot(n, h)), myshape.shader.exponent)
                    r += myshape.shader.specularColor[0] * intesity[0] * spec
                    g += myshape.shader.specularColor[1] * intesity[1] * spec
                    b += myshape.shader.specularColor[2] * intesity[2] * spec
    c = Color(r,g,b)
    c.gammaCorrect(2.2)
    return  c.toUINT8()

def main():
    tree = ET.parse(sys.argv[1])
    root = tree.getroot()

    # set default values
    viewDir = np.array([0,0,-1]).astype(np.float64)
    viewUp = np.array([0,1,0]).astype(np.float64)
    viewProjNormal = -1*viewDir  # you can safely assume this. (no examples will use shifted perspective camera)
    viewWidth = 1.0
    viewHeight = 1.0
    projDistance = 1.0
    intensity = np.array([1,1,1]).astype(np.float64)  # how bright the light is.

    imgSize=np.array(root.findtext('image').split()).astype(np.int64)

    for c in root.findall('camera'):
        viewPoint = np.array(c.findtext('viewPoint').split()).astype(np.float64)
        if(c.findtext('viewDir')):
            viewDir = np.array(c.findtext('viewDir').split()).astype(np.float64)
        if(c.findtext('projNormal')):
            viewProjNormal = np.array(c.findtext('projNormal').split()).astype(np.float64)
        if(c.findtext('viewUp')):
            viewUp = np.array(c.findtext('viewUp').split()).astype(np.float64)
        if(c.findtext('projDistance')):
            projDistance = np.array(c.findtext('projDistance').split()).astype(np.float64)
        if(c.findtext('viewWidth')):
            viewWidth=np.array(c.findtext('viewWidth').split()).astype(np.float64)
        if(c.findtext('viewHeight')):
            viewHeight = np.array(c.findtext('viewHeight').split()).astype(np.float64)

        camera = Camera(viewPoint= viewPoint, viewDir= viewDir, viewProjNormal= viewProjNormal, viewProjDistance= projDistance, viewUp= viewUp, viewWidth= viewWidth, viewHeight= viewHeight)
    
    shaders = []
    for c in root.findall('shader'):
        diffuseColor = np.array(c.findtext('diffuseColor').split()).astype(np.float64)
        name = c.get('name')
        shadertype = c.get('type')
        specularColor = c.findtext('specularColor')
        exponent = c.findtext('exponent')

        newShader = Shader(name = name, type = shadertype, diffuseColor= diffuseColor, specularColor= specularColor, exponent= exponent)
        shaders.append(newShader)

    shapes = []
    for c in root.findall('surface'):
        type = c.get('type')    
        radius = np.array(c.findtext('radius')).astype(np.float64)
        center = np.array(c.findtext('center').split()).astype(np.float64)
        shader = c.find('shader')
        ref = shader.get('ref')
        targetshader = None
        for myshader in shaders:
            if myshader.name == ref:
                targetshader = myshader
                break

        newShape = Shape(surfacetype= type, radius= radius, center = center, shader= targetshader)
        shapes.append(newShape)

    lights = []
    for c in root.findall('light'):
        position = np.array(c.findtext('position').split()).astype(np.float64)
        intensity = np.array(c.findtext('intensity').split()).astype(np.float64)

        newlight = Light(position= position, intensity= intensity)
        lights.append(newlight)
    #code.interact(local=dict(globals(), **locals()))  

    # Create an empty image
    channels=3
    img = np.zeros((imgSize[1], imgSize[0], channels), dtype=np.uint8)
    img[:,:]=0

    # replace the code block below!
    vP = camera.viewPoint
    vD = camera.viewDir

    vD = vD/np.sqrt((vD@vD)) # normalizing vD

    a = camera.viewUp
    a = a/np.sqrt((a@a)) # normalizing vD

    u=np.cross(vD,a)
    u=u/np.sqrt((u@u)) # normalizing u

    v=np.cross(vD,u)
    v =v/np.sqrt((v@v)) # normalizing v

    uu = u * (camera.viewWidth / imgSize[0]) * (imgSize[0]/2)
    vv = v * (camera.viewHeight / imgSize[1]) * (imgSize[1]/2)
    p = vD * camera.viewProjDistance - uu - vv
    
    img = np.zeros((imgSize[1], imgSize[0], 3), dtype=np.uint8)


    for x in np.arange(imgSize[0]):
        for y in np.arange(imgSize[1]):
            ray = p + u*x*(camera.viewWidth / imgSize[0]) + v*y*(camera.viewHeight/imgSize[1])

            index = -1
            mv = np.finfo(np.float64).max

            for shape in shapes:
                x2 = np.sum(ray*ray)
                cx = np.sum((camera.viewPoint- shape.center)*ray)
                c2r2 = np.sum((camera.viewPoint - shape.center)**2) - shape.radius**2
                i = cx**2 - x2*c2r2

                if(i >= 0):
                    w = np.sqrt(i)
                    s = -cx + w
                    t = -cx - w
                    if(s >= 0 and mv >= s/x2):
                        mv = s / x2
                        index = shapes.index(shape)
                    if(s >= 0 and mv >= t/x2):
                        mv = t / x2
                        index = shapes.index(shape)    

            if(index != -1):
                img[y][x] = Raytrace(mv*ray, camera.viewPoint, shapes, index, lights)
            else:
                img[y][x] = np.array([0, 0, 0]) # default

    rawimg = Image.fromarray(img, 'RGB')
    rawimg.save(sys.argv[1]+'.png')

if __name__=="__main__":
    main()