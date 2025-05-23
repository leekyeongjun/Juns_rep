import glfw
from OpenGL.GL import * 
from OpenGL.GLU import *
import numpy as np
import pdb


def drawUnitCube():
    glBegin(GL_QUADS)
    glVertex3f( 0.5, 0.5,-0.5)
    glVertex3f(-0.5, 0.5,-0.5)
    glVertex3f(-0.5, 0.5, 0.5)
    glVertex3f( 0.5, 0.5, 0.5) 
                             
    glVertex3f( 0.5,-0.5, 0.5)
    glVertex3f(-0.5,-0.5, 0.5)
    glVertex3f(-0.5,-0.5,-0.5)
    glVertex3f( 0.5,-0.5,-0.5) 
                             
    glVertex3f( 0.5, 0.5, 0.5)
    glVertex3f(-0.5, 0.5, 0.5)
    glVertex3f(-0.5,-0.5, 0.5)
    glVertex3f( 0.5,-0.5, 0.5)
                             
    glVertex3f( 0.5,-0.5,-0.5)
    glVertex3f(-0.5,-0.5,-0.5)
    glVertex3f(-0.5, 0.5,-0.5)
    glVertex3f( 0.5, 0.5,-0.5)
 
    glVertex3f(-0.5, 0.5, 0.5) 
    glVertex3f(-0.5, 0.5,-0.5)
    glVertex3f(-0.5,-0.5,-0.5) 
    glVertex3f(-0.5,-0.5, 0.5) 
                             
    glVertex3f( 0.5, 0.5,-0.5) 
    glVertex3f( 0.5, 0.5, 0.5)
    glVertex3f( 0.5,-0.5, 0.5)
    glVertex3f( 0.5,-0.5,-0.5)
    glEnd()

def drawCubeArray():
    for i in range(5):
        for j in range(5):
            for k in range(5):
                glPushMatrix()
                glTranslatef(i,j,-k-1)
                glScalef(.5,.5,.5)
                drawUnitCube()
                glPopMatrix()

def drawFrame():
    glBegin(GL_LINES)
    glColor3ub(255, 0, 0)
    glVertex3fv(np.array([0.,0.,0.]))
    glVertex3fv(np.array([1.,0.,0.]))
    glColor3ub(0, 255, 0)
    glVertex3fv(np.array([0.,0.,0.]))
    glVertex3fv(np.array([0.,1.,0.]))
    glColor3ub(0, 0, 255)
    glVertex3fv(np.array([0.,0.,0]))
    glVertex3fv(np.array([0.,0.,1.]))
    glEnd()

def key_callback(window, key, scancode, action, mods):
    pass

def render(t):
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glEnable(GL_DEPTH_TEST)
    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)
    glLoadIdentity()



    glOrtho(-5, 5, -5, 5, -8, 8)
    # 카메라가 5,3,5 에서 1,-1,1을 보고있었다.
    # 먼저 이 카메라가 보고있던 방향의 반대로 돌리고, 다음에 월드를 움직인다.
    # 그러면 보이는 것은 차이가 없게 된다.

    # arctan2 탄젠트 값을 만드는 각도 구하는 함수

    RadXZ = np.degrees(np.arctan2(1, np.sqrt(13)))
    RadY = np.degrees(np.arctan2(2,3))
    glRotatef(-RadY, 0, 1, 0)
    glRotatef(RadXZ, 3, 0, -2)
    glTranslatef(-5, -3, -5)

 


    drawFrame()

    glColor3ub(255, 255, 255)
    drawCubeArray()

def main():
    global RadX, RadY


    if not glfw.init():
        return
    window = glfw.create_window(640,640, "3D Trans", None,None)
    if not window: 
        glfw.terminate() 
        return
    glfw.make_context_current(window) 
    glfw.set_key_callback(window, key_callback)
    glfw.swap_interval(1)
    while not glfw.window_should_close(window): 
        glfw.poll_events()
        t = glfw.get_time()
        render(t)

        glfw.swap_buffers(window) 
    glfw.terminate()

if __name__ == "__main__": 
    main()
