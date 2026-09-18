#ifndef OBJECTS_H
#define OBJECTS_H

/*
 * Коды объектов work_cave[880] (карта 40x22).
 *
 * Это не «типы тайлов для рисования», а состояние клетки физики C64
 * (ProcessCave $7dd9). Один байт кодирует И вид объекта, И фазу:
 * «уже обработан в этом тике» / «падает» / «стадия взрыва».
 *
 * Скан идёт слева направо, сверху вниз, строки 1..20 (края — сталь).
 * Когда валун падает вниз, он пишется в клетку i+40 кодом *_S (scanned).
 * Скан дойдёт до этой клетки в том же тике и обязан её ПРОПУСТИТЬ —
 * иначе объект обработается дважды за кадр. На следующем тике *_S
 * превращается в *_F (falling) и снова участвует в физике.
 *
 * Поэтому таблица MapObj[] в labirint.c имеет 45 слотов: каждому коду,
 * включая служебные, соответствует спрайт (часто тот же, что у базового
 * объекта — падающий валун выглядит как лежащий).
 */

/* --- Базовые (не сканированные в этом тике) --- */
#define O_EMPTY       0x00
#define O_STEEL       0x01  /* нерушима даже взрывом 3x3 */
#define O_DIRT        0x02
#define O_BRICK       0x03  /* круглая: валун/алмаз скатывается */
#define O_BOULDER     0x04
#define O_FIREFLY     0x05  /* в распакованной карте; сразу -> направленный */
#define O_DIAMOND     0x06
#define O_BUTTERFLY   0x07  /* то же: распаковка превращает в O_BF_* */
#define O_EXIT        0x08
#define O_INBOX       0x09  /* точка появления Rockford, потом сталь */
#define O_AMOEBA      0x0A
#define O_MAGIC       0x0B  /* magic wall: валун <-> алмаз, пока активна */

/* --- Уже падают (обязаны дойти до falling_tick, даже если клетка снизу «мёртвая») --- */
#define O_BOULDER_F   0x0C
#define O_DIAMOND_F   0x0D

/* --- Scanned: положены в этом тике, на следующем станут падающими --- */
#define O_BOULDER_S   0x0E
#define O_DIAMOND_S   0x0F

/* --- Светлячок: 4 направления. Ходит ПРОТИВ часовой (C64). --- */
#define O_FF_UP       0x10
#define O_FF_RIGHT    0x11
#define O_FF_DOWN     0x12
#define O_FF_LEFT     0x13

/* --- Бабочка: по часовой. Взрыв бабочки даёт алмазы, светлячка — пустоту. --- */
#define O_BF_UP       0x14
#define O_BF_RIGHT    0x15
#define O_BF_DOWN     0x16
#define O_BF_LEFT     0x17

/* --- Взрыв, 5 стадий. S* -> пустота, D* -> алмаз. Сталь в 3x3 не трогается. --- */
#define O_EXPL_S1     0x18
#define O_EXPL_S5     0x1C
#define O_EXPL_D1     0x1D
#define O_EXPL_D5     0x21

#define O_ROCKFORD    0x22
#define O_AMOEBA_A    0x23  /* активная амёба (после распаковки 0x0A -> 0x23) */

/* Scanned-критеры и амёба: сдвиг кода, чтобы скан не обработал их повторно */
#define O_BF_UP_S     0x24
#define O_BF_RIGHT_S  0x25
#define O_BF_DOWN_S   0x26
#define O_BF_LEFT_S   0x27
#define O_FF_UP_S     0x28
#define O_FF_RIGHT_S  0x29
#define O_FF_DOWN_S   0x2A
#define O_FF_LEFT_S   0x2B
#define O_AMOEBA_S    0x2C

#endif
