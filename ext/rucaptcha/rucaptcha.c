// http://github.com/ITikhonov/captcha
const int gifsize;
void captcha(unsigned char im[70*200], unsigned char l[8], int length, int i_line, int i_filter);
void makegif(unsigned char im[70*200], unsigned char gif[gifsize], int style);

#include <unistd.h>
#include <stdint.h>
#include <stdlib.h>
#include <fcntl.h>
#include <string.h>
#include <time.h>
#include <ruby.h>
#include "font.h"
#include "colors.h"

static int8_t *lt[];
const int gifsize=17646;

void makegif(unsigned char im[70*200], unsigned char gif[gifsize], int style) {
  // tag ; widthxheight ; GCT:0:0:7 ; bgcolor + aspect // GCT
  // Image Separator // left x top // widthxheight // Flags
  // LZW code size
  srand(time(NULL));
  int color_len = (int) sizeof(colors) / sizeof(colors[0]);
  int color_idx = rand() % color_len;
  if (style == 0) {
    color_idx = 0;
  }
  memcpy(gif,colors[color_idx],13+48+10+1);

  int x,y;
  unsigned char *i=im;
  unsigned char *p=gif+13+48+10+1;
  for(y=0;y<70;y++) {
    *p++=250; // Data length 5*50=250
    for(x=0;x<50;x++)
    {
      unsigned char a=i[0]>>4,b=i[1]>>4,c=i[2]>>4,d=i[3]>>4;

      p[0]=16|(a<<5);     // bbb10000
      p[1]=(a>>3)|64|(b<<7);  // b10000xb
      p[2]=b>>1;      // 0000xbbb
      p[3]=1|(c<<1);    // 00xbbbb1
      p[4]=4|(d<<3);    // xbbbb100
      i+=4;
      p+=5;
    }
  }

  // Data length // End of LZW (b10001) // Terminator // GIF End
  memcpy(gif+gifsize-4,"\x01" "\x11" "\x00" ";",4);
}

static const int8_t sw[200]={0, 4, 8, 12, 16, 20, 23, 27, 31, 35, 39, 43, 47, 50, 54, 58, 61, 65, 68, 71, 75, 78, 81, 84, 87, 90, 93, 96, 98, 101, 103, 105, 108, 110, 112, 114, 115, 117, 119, 120, 121, 122, 123, 124, 125, 126, 126, 127, 127, 127, 127, 127, 127, 127, 126, 126, 125, 124, 123, 122, 121, 120, 119, 117, 115, 114, 112, 110, 108, 105, 103, 101, 98, 96, 93, 90, 87, 84, 81, 78, 75, 71, 68, 65, 61, 58, 54, 50, 47, 43, 39, 35, 31, 27, 23, 20, 16, 12, 8, 4, 0, -4, -8, -12, -16, -20, -23, -27, -31, -35, -39, -43, -47, -50, -54, -58, -61, -65, -68, -71, -75, -78, -81, -84, -87, -90, -93, -96, -98, -101, -103, -105, -108, -110, -112, -114, -115, -117, -119, -120, -121, -122, -123, -124, -125, -126, -126, -127, -127, -127, -127, -127, -127, -127, -126, -126, -125, -124, -123, -122, -121, -120, -119, -117, -115, -114, -112, -110, -108, -105, -103, -101, -98, -96, -93, -90, -87, -84, -81, -78, -75, -71, -68, -65, -61, -58, -54, -50, -47, -43, -39, -35, -31, -27, -23, -20, -16, -12, -8, -4};


#define MAX(x,y) ((x>y)?(x):(y))

static int letter(int n, int pos, unsigned char im[70*200], unsigned char swr[200], uint8_t s1, uint8_t s2) {
  int8_t *p=lt[n];
  unsigned char *r=im+200*16+pos;
  unsigned char *i=r;
  int sk1=s1+pos;
  int sk2=s2+pos;
  int mpos=pos;
  int row=0;
  for(;*p!=-101;p++) {
    if(*p<0) {
      if(*p==-100) { r+=200; i=r; sk1=s1+pos; row++; continue; }
      i+=-*p;
      continue;
    }

    if(sk1>=200) sk1=sk1%200;
    int skew=sw[sk1]/16;
    sk1+=(swr[pos+i-r]&0x1)+1;

    if(sk2>=200) sk2=sk2%200;
    int skewh=sw[sk2]/70;
    sk2+=(swr[row]&0x1);

    unsigned char *x=i+skew*200+skewh;
    mpos=MAX(mpos,pos+i-r);

    if((x-im)<70*200) *x=(*p)<<4;
    i++;
  }
  return mpos + 3;
}

#define NDOTS 10

uint32_t dr[NDOTS];

static void line(unsigned char im[70*200], unsigned char swr[200], uint8_t s1) {
  int x;
  int sk1=s1;
  for(x=0;x<199;x++) {
    if(sk1>=200) sk1=sk1%200;
    int skew=sw[sk1]/20;
    sk1+=swr[x]&0x3+1;
    unsigned char *i= im+(200*(45+skew)+x);
    i[0]=0; i[1]=0; i[200]=0; i[201]=0;
  }
}

static void dots(unsigned char im[70*200]) {
  int n;
  for(n=0;n<NDOTS;n++) {
    uint32_t v=dr[n];
    unsigned char *i=im+v%(200*67);

    i[0]=0xff;
    i[1]=0xff;
    i[2]=0xff;
    i[200]=0xff;
    i[201]=0xff;
    i[202]=0xff;
  }
}

static void blur(unsigned char im[70*200]) {
  unsigned char *i=im;
  int x,y;
  for(y=0;y<68;y++) {
    for(x=0;x<198;x++) {
      unsigned int c11=*i,c12=i[1],c21=i[200],c22=i[201];
      *i++=((c11+c12+c21+c22)/4);
    }
  }
}

static void filter(unsigned char im[70*200]) {
  unsigned char om[70*200];
  unsigned char *i=im;
  unsigned char *o=om;

  memset(om,0xff,sizeof(om));

  int x,y;
  for(y=0;y<70;y++) {
    for(x=4;x<200-4;x++) {
      if(i[0]>0xf0 && i[1]<0xf0) { o[0]=0; o[1]=0; }
      else if(i[0]<0xf0 && i[1]>0xf0) { o[0]=0; o[1]=0; }

      i++;
      o++;
    }
  }

  memmove(im,om,sizeof(om));
}

static const char *letters="abcdafahijklmnopqrstuvwxyz";

void captcha(unsigned char im[70*200], unsigned char l[8], int length, int i_line, int i_filter) {
  unsigned char swr[200];
  uint8_t s1,s2;

  int f=open("/dev/urandom",O_RDONLY);
  read(f,l,5); read(f,swr,200); read(f,dr,sizeof(dr)); read(f,&s1,1); read(f,&s2,1);
  close(f);
  memset(im,0xff,200*70); s1=s1&0x7f; s2=s2&0x3f;

  int x;
  for(x=0;x<length;x++){
    l[x]%=25;
  }
  for(x=length;x<8;x++){
    l[length]=0;
  }
  //l[0]%=25; l[1]%=25; l[2]%=25; l[3]%=25; l[4]=0; // l[4]%=25; l[5]=0;
  int p=30;
  for(x=0;x<length;x++){
    p=letter(l[x],p,im,swr,s1,s2);
  }

  if (i_line == 1) {
    line(im,swr,s1);
  }
  // dots(im);
  if (i_filter == 1) {
    blur(im);
    filter(im);
  }

  for(x=0;x<length;x++){
    l[x]=letters[l[x]];
  }
  //l[1]=letters[l[1]]; l[2]=letters[l[2]]; l[3]=letters[l[3]]; //l[4]=letters[l[4]];
}

// #ifdef CAPTCHA
//
// int main() {
//   char l[6];
//   unsigned char im[70*200];
//   unsigned char gif[gifsize];
//
//   captcha(im,l);
//   makegif(im,gif);
//
//   write(1,gif,gifsize);
//   write(2,l,5);
//
//   return 0;
// }
//
// #endif

VALUE RuCaptcha = Qnil;

void Init_rucaptcha();

VALUE create(VALUE self, VALUE style, VALUE length, VALUE line, VALUE filter);

void Init_rucaptcha() {
  RuCaptcha = rb_define_module("RuCaptcha");
  rb_define_singleton_method(RuCaptcha, "create", create, 4);
}

VALUE create(VALUE self, VALUE style, VALUE length, VALUE line, VALUE filter) {
  char l[8];
  unsigned char im[80*200];
  unsigned char gif[gifsize];
  int i_style = FIX2INT(style);
  int i_length = FIX2INT(length);
  int i_line = FIX2INT(line);
  int i_filter = FIX2INT(filter);

  captcha(im, l, i_length, i_line, i_filter);
  makegif(im, gif, i_style);

  VALUE result = rb_ary_new2(2);
  rb_ary_push(result, rb_str_new2(l));
  rb_ary_push(result, rb_str_new(gif, gifsize));

  return result;
}

