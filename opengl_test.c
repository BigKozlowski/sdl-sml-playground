#include <SDL2/SDL.h>
#include <SDL2/SDL_opengl.h>
#include <stdio.h>

float angle = 0.0f;
Uint32 lastTime = 0;

float tetrahedron_positions[4][3] = {
    {0, 2, 0},
    {-1, 0, 1},
    {1, 0, 1},
    {0, 0, -1.4}};

float tetrahedron_colors[4][3] = {
    {1, 1, 1},
    {1, 0, 0},
    {0, 1, 0},
    {0, 0, 1}};

void drawGrid()
{
    glColor3f(1, 1, 1);
    glBegin(GL_LINES);
    for (float i = -2.5; i <= 2.5; i += 0.25)
    {
        glVertex3f(i, 0, 2.5);
        glVertex3f(i, 0, -2.5);
        glVertex3f(2.5, 0, i);
        glVertex3f(-2.5, 0, i);
    }
    glEnd();
}

void drawTetra()
{
    glBegin(GL_TRIANGLE_STRIP);
    for (int i = 0; i < 6; i++)
    {
        int ind = i % 4;
        glColor3f(tetrahedron_colors[ind][0], tetrahedron_colors[ind][1], tetrahedron_colors[ind][2]);
        glVertex3f(tetrahedron_positions[ind][0], tetrahedron_positions[ind][1], tetrahedron_positions[ind][2]);
    }
    glEnd();
}

int main(int argc, char *argv[])
{
    SDL_Init(SDL_INIT_VIDEO);
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 2);
    SDL_Window *window = SDL_CreateWindow("Tetra SDL2", 80, 80, 800, 600, SDL_WINDOW_OPENGL);
    SDL_GLContext ctx = SDL_GL_CreateContext(window);

    glEnable(GL_CULL_FACE);
    glCullFace(GL_BACK);
    glClearColor(0.1f, 0.39f, 0.88f, 1.0f);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glFrustum(-2, 2, -1.5, 1.5, 1, 40);

    int running = 1;
    SDL_Event e;
    while (running)
    {
        Uint32 now = SDL_GetTicks();
        float delta = (now - lastTime) / 1000.0f;
        angle += 30.0f * delta; // 30°/сек
        lastTime = now;

        while (SDL_PollEvent(&e))
        {
            if (e.type == SDL_QUIT)
                running = 0;
        }

        glMatrixMode(GL_MODELVIEW);
        glLoadIdentity();
        glTranslatef(0, 0, -3);
        glRotatef(angle, 0, 1, 0);
        glRotatef(angle / 2.0, 1, 0, 0);

        glClear(GL_COLOR_BUFFER_BIT);
        drawGrid();
        drawTetra();
        SDL_GL_SwapWindow(window);
    }

    SDL_GL_DeleteContext(ctx);
    SDL_DestroyWindow(window);
    SDL_Quit();
    return 0;
}