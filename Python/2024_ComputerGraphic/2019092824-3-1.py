import numpy as np
import glfw 
from OpenGL.GL import *

coord_identity = np.array([
    [1., 0., 0.],
    [0., 1., 0.],
    [0., 0., 1.,]
])

GlobalCoord = np.array([
    [1.,0.,0.],
    [0.,1.,0.],
    [0.,0.,1.],
])

LocalCoord = GlobalCoord

t_x = 0
deg = 0
th = np.radians(deg)

def key_callback(window, key, scancode, action, mods):
    global t_x
    global deg
    global th
    global LocalCoord

    if action == glfw.PRESS:
        if key == glfw.KEY_Q and action == glfw.PRESS:
            t_x -= 0.1
        if key == glfw.KEY_E and action == glfw.PRESS:
            t_x += 0.1
        if key == glfw.KEY_A and action == glfw.PRESS:
            deg -= 10
        if key == glfw.KEY_D and action == glfw.PRESS: 
            deg += 10    
        if key == glfw.KEY_1 and action == glfw.PRESS: 
            t_x = 0
            deg = 0
            th = np.radians(deg)

            LocalCoord = coord_identity

        T_coords = np.array([
            [1.,0.,t_x],
            [0.,1.,0.],
            [0.,0.,1.],
        ])

        th = np.radians(deg)

        R_coords = np.array([
            [np.cos(th),np.sin(th),0],
            [-np.sin(th),np.cos(th),0],
            [0.,0.,1.,]
        ])
        
        LocalCoord = T_coords
        LocalCoord @= R_coords
        """
        print("=== Something Pressed ===")

        print("tx : ", t_x , " deg : ", deg)

        print("Tcoords")
        print(T_coords)
        print()

        print("Rcoords")
        print(R_coords)
        print()
        
        print("LocalCoords")
        print(LocalCoord)
        print()
        """

def render(T):
    glClear(GL_COLOR_BUFFER_BIT)
    glLoadIdentity()
    #draw coordinates
    
    glBegin(GL_LINES)
    glColor3ub(255, 0, 0)
    glVertex2fv(np.array([0.,0.]))
    glVertex2fv(np.array([1.,0.]))
    glColor3ub(0, 255, 0)
    glVertex2fv(np.array([0.,0.]))
    glVertex2fv(np.array([0.,1.]))
    glEnd()

    # draw triangle
    glBegin(GL_TRIANGLES)
    glColor3ub(255, 255, 255),
    glVertex2fv((T @ np.array([.0,.5,1.]))[:-1])
    glVertex2fv((T @ np.array([.0,.0,1.]))[:-1])
    glVertex2fv((T @ np.array([.5,.0,1.]))[:-1])
    glEnd()


def main():
    # Initialize the library
    if not glfw.init():
        return
    # Create a windowed mode window and itsOpenGLcontext
    window = glfw.create_window(480,480,"2019092824-3-2",None,None)
    if not window:
        glfw.terminate()
        return
    # Make the window's context current

    glfw.make_context_current(window)
    glfw.set_key_callback(window, key_callback)
    glfw.swap_interval(1)
    

    while not glfw.window_should_close(window):
        glfw.poll_events()
        render(LocalCoord)
        glfw.swap_buffers(window)
    glfw.terminate()

if __name__ == "__main__":
    main()
