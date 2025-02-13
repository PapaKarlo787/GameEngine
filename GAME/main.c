#include "dos.h"
#include "stdio.h"
#include "stdlib.h"
#include "display.h"
#include "music.h"
#include "irq.h"

short doom[] = {82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 79, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 79, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 79, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 185, 9, 147, 9, 123, 9, 220, 9, 185, 9, 123, 9, 147, 9, 185, 9, 220, 9, 185, 9, 147, 9, 123, 9, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 79, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 247, 9, 196, 9, 165, 9, 196, 9, 247, 9, 330, 9, 196, 9, 247, 9, 330, 9, 247, 9, 392, 9, 494, 9, 110, 13, 110, 13, 220, 13, 110, 13, 110, 13, 196, 13, 110, 13, 110, 13, 175, 13, 110, 13, 110, 13, 156, 13, 110, 13, 110, 13, 165, 13, 175, 13, 110, 13, 110, 13, 220, 13, 110, 13, 110, 13, 196, 13, 110, 13, 110, 13, 175, 13, 110, 13, 110, 13, 156, 79, 110, 13, 110, 13, 220, 13, 110, 13, 110, 13, 196, 13, 110, 13, 110, 13, 175, 13, 110, 13, 110, 13, 156, 13, 110, 13, 110, 13, 165, 13, 175, 13, 110, 13, 110, 13, 220, 13, 110, 13, 110, 13, 196, 13, 110, 13, 110, 13, 220, 9, 175, 9, 147, 9, 220, 9, 175, 9, 147, 9, 262, 9, 220, 9, 175, 9, 220, 9, 175, 9, 147, 9, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 79, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 79, 139, 13, 139, 13, 277, 13, 139, 13, 139, 13, 247, 13, 139, 13, 139, 13, 220, 13, 139, 13, 139, 13, 196, 13, 139, 13, 139, 13, 208, 13, 220, 13, 123, 13, 123, 13, 247, 13, 123, 13, 123, 13, 220, 13, 123, 13, 123, 13, 196, 13, 123, 13, 123, 13, 175, 79, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 247, 9, 196, 9, 165, 9, 196, 9, 247, 9, 330, 9, 196, 9, 247, 9, 330, 9, 247, 9, 392, 9, 494, 9, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 79, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 185, 9, 156, 9, 123, 9, 185, 9, 156, 9, 123, 9, 196, 9, 147, 9, 123, 9, 311, 9, 156, 9, 123, 9, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 79, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 330, 9, 247, 9, 196, 9, 392, 9, 330, 9, 196, 9, 247, 9, 294, 9, 330, 9, 392, 9, 330, 9, 196, 9, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 79, 110, 13, 110, 13, 220, 13, 110, 13, 110, 13, 196, 13, 110, 13, 110, 13, 175, 13, 110, 13, 110, 13, 156, 13, 110, 13, 110, 13, 165, 13, 175, 13, 110, 13, 110, 13, 220, 13, 110, 13, 110, 13, 196, 13, 110, 13, 110, 13, 220, 9, 175, 9, 147, 9, 220, 9, 175, 9, 147, 9, 262, 9, 220, 9, 175, 9, 220, 9, 175, 9, 147, 9, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 79, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 79, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 79, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 247, 9, 196, 9, 165, 9, 123, 9, 165, 9, 196, 9, 262, 9, 247, 9, 196, 9, 247, 9, 196, 9, 165, 9, -1};
short doom2[] = {82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 79, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 79, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 79, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 185, 9, 147, 9, 123, 9, 220, 9, 185, 9, 123, 9, 147, 9, 185, 9, 220, 9, 185, 9, 147, 9, 123, 9, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 79, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 247, 9, 196, 9, 165, 9, 196, 9, 247, 9, 330, 9, 196, 9, 247, 9, 330, 9, 247, 9, 392, 9, 494, 9, 110, 13, 110, 13, 220, 13, 110, 13, 110, 13, 196, 13, 110, 13, 110, 13, 175, 13, 110, 13, 110, 13, 156, 13, 110, 13, 110, 13, 165, 13, 175, 13, 110, 13, 110, 13, 220, 13, 110, 13, 110, 13, 196, 13, 110, 13, 110, 13, 175, 13, 110, 13, 110, 13, 156, 79, 110, 13, 110, 13, 220, 13, 110, 13, 110, 13, 196, 13, 110, 13, 110, 13, 175, 13, 110, 13, 110, 13, 156, 13, 110, 13, 110, 13, 165, 13, 175, 13, 110, 13, 110, 13, 220, 13, 110, 13, 110, 13, 196, 13, 110, 13, 110, 13, 220, 9, 175, 9, 147, 9, 220, 9, 175, 9, 147, 9, 262, 9, 220, 9, 175, 9, 220, 9, 175, 9, 147, 9, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 79, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 79, 139, 13, 139, 13, 277, 13, 139, 13, 139, 13, 247, 13, 139, 13, 139, 13, 220, 13, 139, 13, 139, 13, 196, 13, 139, 13, 139, 13, 208, 13, 220, 13, 123, 13, 123, 13, 247, 13, 123, 13, 123, 13, 220, 13, 123, 13, 123, 13, 196, 13, 123, 13, 123, 13, 175, 79, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 247, 9, 196, 9, 165, 9, 196, 9, 247, 9, 330, 9, 196, 9, 247, 9, 330, 9, 247, 9, 392, 9, 494, 9, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 79, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 185, 9, 156, 9, 123, 9, 185, 9, 156, 9, 123, 9, 196, 9, 147, 9, 123, 9, 311, 9, 156, 9, 123, 9, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 79, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 330, 9, 247, 9, 196, 9, 392, 9, 330, 9, 196, 9, 247, 9, 294, 9, 330, 9, 392, 9, 330, 9, 196, 9, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 79, 110, 13, 110, 13, 220, 13, 110, 13, 110, 13, 196, 13, 110, 13, 110, 13, 175, 13, 110, 13, 110, 13, 156, 13, 110, 13, 110, 13, 165, 13, 175, 13, 110, 13, 110, 13, 220, 13, 110, 13, 110, 13, 196, 13, 110, 13, 110, 13, 220, 9, 175, 9, 147, 9, 220, 9, 175, 9, 147, 9, 262, 9, 220, 9, 175, 9, 220, 9, 175, 9, 147, 9, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 79, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 79, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 79, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 131, 13, 82, 13, 82, 13, 117, 13, 82, 13, 82, 13, 123, 13, 131, 13, 82, 13, 82, 13, 165, 13, 82, 13, 82, 13, 147, 13, 82, 13, 82, 13, 247, 9, 196, 9, 165, 9, 123, 9, 165, 9, 196, 9, 262, 9, 247, 9, 196, 9, 247, 9, 196, 9, 165, 9, -1};

short* mus[] = {doom, doom2};

int main() {
	init_irq();
	//init_display();
	timer_add_subscriber(M_handler);
	timer_add_subscriber(refresh_screen);
	init_display("res.pkg");
	M_play(mus, 2);
	while(1);
	uninit_irq();
	return 0;
}
