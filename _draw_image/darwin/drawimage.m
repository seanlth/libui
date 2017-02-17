#import "ui.h"
#import "uipriv_darwin.h"


// drawimage.m
struct uiPixmapImage {
       CGContextRef c;
       void *bmapdata;
       int w, h, rowstride;
};

uiPixmapImage *uiNewPixmapImage(int w, int h)
{
	uiPixmapImage *img = uiNew(uiPixmapImage);

	/*
	 * Round up to the nearest multiple of 16 since that's the
	 * optimal rowstride according to Quartz documentation.
	 */
	img->rowstride = (w * 4) + 0xf & ~0xf;
	img->w = w;
	img->h = h;
	img->bmapdata = uiAlloc(h * img->rowstride, "imgdata");

	img->c = CGBitmapContextCreate(img->bmapdata, w, h, 8, img->rowstride, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);

	return img;
}

void uiFreePixmapImage(uiPixmapImage *img)
{
	uiFree(img->bmapdata);
	CGContextRelease(img->c);
	uiFree(img);
}

// always little endian ARGB for now.
static const uiPixmap32Format default_fmt = uiPixmap32FormatHasAlpha | uiPixmap32FormatAlphaPremultiplied | uiPixmap32FormatZeroRowBottom | uiPixmap32FormatOffsets(3, 2, 1, 0);

void uiPixmapImageGetData(uiPixmapImage *img, uiImageData *id)
{
	id->fmt = default_fmt;
	id->width = img->w;
	id->height = img->h;
	id->rowstride = img->rowstride;
	id->data = img->bmapdata;
}

void uiImageLoadPixmap32Raw(uiPixmapImage *img, int x, int y, int width, int height, int rowstrideBytes, uiPixmap32Format fmt, void *data)
{
	int dw = img->w;
	int dh = img->h;
	int sw = width + x > dw ? dw : width;
	int sh = height + y > dh ? dh : height;
	int drs = img->rowstride / 4;
	int srs = rowstrideBytes / 4;
	uint32_t *dst = img->bmapdata;

	if ((rowstrideBytes & 3) != 0)
		userbug("rowstride is not divisble by 4, your code must be actively hostile to generate that");

	pixmap32RawCopy(sw, sh, srs, data, fmt, drs, &dst[y * drs + x], default_fmt);
}

// from draw.m
void uiDrawPixmapImage(uiDrawContext *c, double x, double y, uiPixmapImage *img)
{
       CGContextDrawImage(c->c, CGRectMake(x, y, img->w, img->h), CGBitmapContextCreateImage(img->c));
}
