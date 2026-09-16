#include <string.h>
#include <stdint.h>
#include "main.h"

/*
 * bd_levels.c — распаковка пещер и камера.
 *
 * work_cave[880] = 40 колонок x 22 строки. Края (строки 0 и 21,
 * колонки 0 и 39) — сталь; физика сканирует только 800 внутренних клеток.
 * 20 пещер A-T лежат в caves_zx.c в формате nibble+RLE (17600 -> 5780 байт).
 */
void copy_sprites_from_cave(void);
char work_cave[880];
uint16_t elementNumber;

void cave_unpack(unsigned char *src, unsigned char *dst)
{
/*
 * Распаковка пещеры: nibble-pack + RLE -> 880 байт work_cave.
 *
 * На C64 каждая клетка — ниббл (0..15). Две клетки упакованы в байт
 * (старший ниббл — левая). Поверх этого — простой RLE:
 *   token 0x00..0x7F  — следующий байт повторить (token+1) раз
 *   token 0x80..0xFF  — дальше (token-0x7F) литеральных байт
 * Каждый распакованный байт снова делится на два ниббла-клетки.
 * Итого 20 пещер: 17600 байт карты -> 5780 байт в caves_zx.c.
 */
  unsigned char *end = dst + 880;
  while (dst < end) {
    unsigned char token = *src++;
    if (token < 0x80) {
      unsigned char cnt = token + 1;
      unsigned char b = *src++;
      unsigned char hi = b >> 4;
      unsigned char lo = b & 0x0F;
      while (cnt--) {
        *dst++ = hi;
        *dst++ = lo;
      }
    } else {
      unsigned char cnt = token - 0x80 + 1;
      while (cnt--) {
        unsigned char b = *src++;
        *dst++ = b >> 4;
        *dst++ = b & 0x0F;
      }
    }
  }
}

void fill_temp_map_scroll_beton(void)
{
int r=0;
    while(r<880)
    {
    work_cave[r++] = 0x08;
    }
}

int start_cave(char cav)
{
  uint16_t n;
  uint16_t p = 0;
  invalidate_window();
  fill_temp_map_scroll_beton();
  for (n = 0; n < 10; n++) {
    show_window();
    sprites_anim();
  }
  cave_unpack(CaveZxObj[cav], work_cave);
  while (p < 880) {
    if (work_cave[p] == 0x09) n = p;
    p++;
  }
  return n;
}

   // put_dec(0,1, element_position_x);
   // put_dec(10,1, element_position_y);
void move_camera_up(void)
{
if (map_y!=0) map_y--;
}
void move_camera_down(void)
{
if (map_y<12) map_y++;
}

void move_camera_left(void)
{
/*#asm
    lda _sdvig
    cpi 0
    jz sdl1
    dcr a
    sta _sdvig
    ret
sdl1:
    mvi a,5
    sta _sdvig
    lda _map_x
    cpi 0
    jz exit_sdl
    dcr a
    sta _map_x
exit_sdl:
    ret
#endasm*/
    if (sdvig>0)
    {
        sdvig -= 2;        // 4→2→0 — 3 кадра на тайл
    }
    else
    {
        if (map_x>0)
        {
            sdvig = 4;
            map_x--;
        }
    }
}

void move_camera_right(void)
{
    if (sdvig < 4)
    {
        if (map_x < 28)      // не увеличиваем sdvig на границе — некуда рендерить доп. спрайт
        {
            sdvig += 2;
        }
    }
    else
    {
        if (map_x < 28)
        {
            sdvig = 0;
            map_x++;
        }
    }
}


// ������� ��� ����������� ���� � �������� �����������
void move_window_to_coords(char target_x, char target_y) {
    // ���������� ���� � ������� �����
    while (map_y != target_y /*|| map_x != target_x*/) {
        if (map_y > target_y) map_y--;//move_camera_up(); //if (map_y!=0) map_y--;
        if (map_y < target_y) map_y++;//move_camera_down();//if (map_y<11) map_y++;
        show_window();
        sprites_anim();   
    }
    while(map_x != target_x)
    {
      if (map_x < target_x) map_x++;
      if (map_x > target_x) map_x--; 
        show_window();
        sprites_anim(); 
    }
}


// ������� ��������� ����� ���� ��� ����������� ���������� ��������
void calculateWindowCenter(void)
{
    // ������� ����
    uint8_t fieldWidth = 40;
    uint8_t fieldHeight = 22;
    
    // ������� ����
    uint8_t windowWidth = 12;
    uint8_t windowHeight = 10;
    uint8_t element_position_x;
    uint8_t element_position_y;
    char target_x;  // 
    char target_y;  // 
    uint8_t t_row;
    uint8_t t_col;
    element_position_y = elementNumber / fieldWidth;
    element_position_x = elementNumber % fieldWidth;  // 
   // put_dec(0,1, element_position_x);
   // put_dec(10,1, element_position_y);

    map_x = element_position_x - windowWidth / 2;
    map_y = element_position_y - windowHeight / 2;

// ��������� ������� ������ �� ������� �����
    if (map_x < 0) {
        map_x = 0;
    }
    if (map_x + windowWidth > fieldWidth) {
        map_x = fieldWidth - windowWidth;
    }
    if (map_y < 0) {
        map_y = 0;
    }
    if (map_y + windowHeight > fieldHeight) {
        map_y = fieldHeight - windowHeight;
    }
    target_x = map_x; target_y = map_y;
    // put_dec(30,1, man_position_x); put_dec(40,1, man_position_y);
   // put_dec(20,0, elementNumber);
    // put_dec(30,0, target_x); put_dec(40,0, target_y);
   //  while(1);  

  map_x = random(0, 39);
  map_x = map_x - windowWidth / 2;
      if (map_x < 0) map_x = 0;
    if (map_x + windowWidth > fieldWidth) {
        map_x = fieldWidth - windowWidth;
    }
  map_y = random(0, 21);
  map_y = map_y - windowHeight / 2;
  if (map_y < 0) map_y = 0;
    if (map_y + windowHeight > fieldHeight) {
        map_y = fieldHeight - windowHeight;
    }
  move_window_to_coords(target_x, target_y);
 //if (map_x==0) {put_text(0,0, 'o',1);} else {put_dec(0,0, map_x);}
 //if (map_y==0) {put_text(10,0, 'o',1);} else { put_dec(10,0, map_y);}

       
        
   
}





