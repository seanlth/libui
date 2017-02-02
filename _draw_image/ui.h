#ifndef __LIBUI_UI_DRAW_IMAGE_H__
#define __LIBUI_UI_DRAW_IMAGE_H__

/*
 * uiPixmap32Format encodes how a pixmap is formatted.
 * The lower 8 bits encode the byte offsets of each of
 * R, G, B, A channels.
 */
typedef uint32_t uiPixmap32Format;
#define uiPixmap32FormatOffsetA(f)    (((f) >> 0) & 0x3)
#define uiPixmap32FormatOffsetR(f)    (((f) >> 2) & 0x3)
#define uiPixmap32FormatOffsetG(f)    (((f) >> 4) & 0x3)
#define uiPixmap32FormatOffsetB(f)    (((f) >> 6) & 0x3)
#define uiPixmap32FormatOffsets(a,r,g,b)  ((a) << 0 | (r) << 2 | (g) << 4 | (b) << 6)
#define uiPixmap32FormatOffsetMask    0x0ff
#define uiPixmap32FormatHasAlpha    0x100
#define uiPixmap32FormatAlphaPremultiplied  0x200
#define uiPixmap32FormatZeroRowBottom   0x400

typedef struct uiPixmapImage uiPixmapImage;
typedef struct uiImageData uiImageData;
// Externally exported information about the image. Obtained with uiImageGetData.
struct uiImageData {
  uiPixmap32Format fmt;
  int width;
  int height;
  int rowstride;
  void *data;
};
_UI_EXTERN uiPixmapImage *uiNewPixmapImage(int width, int height);
_UI_EXTERN void uiFreePixmapImage(uiPixmapImage *);
_UI_EXTERN uiPixmap32Format uiPixmapImageGetFormat(uiPixmapImage *);
_UI_EXTERN void uiPixmapImageGetData(uiPixmapImage *, uiImageData *);
_UI_EXTERN void uiImageLoadPixmap32Raw(uiPixmapImage *img, int x, int y, int width, int height, int rowstrideBytes, uiPixmap32Format fmt, void *data);

_UI_EXTERN void uiDrawPixmapImage(uiDrawContext *c, double x, double y, uiPixmapImage *img);

#endif
