import numpy as np
import glfw 
from OpenGL.GL import *

render_value = GL_LINE_LOOP

def key_callback(window, key, scancode, action, mods):
    global render_value

    if key==glfw.KEY_0:
        if action==glfw.PRESS:
            render_value = GL_POLYGON
            #print('0')


    if key==glfw.KEY_1:
        if action==glfw.PRESS:
            render_value= GL_POINTS
            #print('1')

    if key==glfw.KEY_2:
        if action==glfw.PRESS:
            render_value = GL_LINES
            #print('2')

    if key==glfw.KEY_3:
        if action==glfw.PRESS:
            render_value= GL_LINE_STRIP
            #print('3')

    if key==glfw.KEY_4:
        if action==glfw.PRESS:
            render_value = GL_LINE_LOOP
            #print('4')

    if key==glfw.KEY_5:
        if action==glfw.PRESS:
            render_value = GL_TRIANGLES
            #print('5')

    if key==glfw.KEY_6:
        if action==glfw.PRESS:
            render_value = GL_TRIANGLE_STRIP
            #print('6')

    if key==glfw.KEY_7:
        if action==glfw.PRESS:
            render_value = GL_TRIANGLE_FAN
            #print('7')

    if key==glfw.KEY_8:
        if action==glfw.PRESS:
            render_value = GL_QUADS
            #print('8')

    if key==glfw.KEY_9:
        if action==glfw.PRESS:
            render_value = GL_QUAD_STRIP
            #print('9')

def render(T, SHAPE_VAR, offset):
    glClear(GL_COLOR_BUFFER_BIT)
    glLoadIdentity()

    glBegin(SHAPE_VAR)
    glColor3ub(255, 255, 255)


    th = np.radians(30)
    R = np.array([[np.cos(th),-np.sin(th)],
                  [np.sin(th),np.cos(th)]])
    
    count = 0
    curvertex = T
    
    while(count != 12 + offset) :
        curvertex @= R
        if(count >= offset) :
            glVertex2fv(curvertex)
        count+=1
    
    glEnd()


def main():
    # Initialize the library
    if not glfw.init():
        return
    # Create a windowed mode window and itsOpenGLcontext
    window = glfw.create_window(480,480,"2019092824-2-1",None,None)
    if not window:
        glfw.terminate()
        return
    # Make the window's context current

    glfw.make_context_current(window)
    glfw.set_key_callback(window, key_callback)
    glfw.swap_interval(1)

    while not glfw.window_should_close(window):
        glfw.poll_events()
        T = np.array([[0.,1.]])
        render(T,render_value,3)
        glfw.swap_buffers(window)
    glfw.terminate()

if __name__ == "__main__":
    main()

"""
1 GL_POINTS
2 GL_LINES
3 GL_LINE_STRIP
4 GL_LINE_LOOP
5 GL_TRIANGLES
6 GL_TRIANGLE_STRIP
7 GL_TRIANGLE_FAN

"""