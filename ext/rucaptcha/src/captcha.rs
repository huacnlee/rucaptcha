use image::{ImageBuffer, Rgba};
use imageproc::{
    drawing::{draw_cubic_bezier_curve_mut, draw_filled_ellipse_mut},
    noise::gaussian_noise_mut,
};
use rand::{thread_rng, Rng};
use rusttype::{Font, Scale};
use std::{io::Cursor, sync::LazyLock};

static BASIC_CHAR: [char; 54] = [
    '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'M',
    'N', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g',
    'h', 'j', 'k', 'm', 'n', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
];

// https://coolors.co/cc0b8f-7c0abe-5700c8-3c2ea4-3d56a8-3fa67e-45bb30-69d003-a0d003-d8db02
static COLORS: [(u8, u8, u8, u8); 14] = [
    (197, 166, 3, 255),
    (187, 87, 5, 255),
    (176, 7, 7, 255),
    (186, 9, 56, 255),
    (204, 11, 143, 255),
    (124, 10, 190, 255),
    (87, 0, 200, 255),
    (61, 86, 168, 255),
    (63, 166, 126, 255),
    (69, 187, 48, 255),
    (105, 208, 3, 255),
    (160, 208, 3, 255),
    (216, 219, 2, 255),
    (50, 50, 50, 255),
];

static SCALE_SM: u32 = 32;
static SCALE_MD: u32 = 45;
static SCALE_LG: u32 = 55;
static FONT_0: LazyLock<Font> = LazyLock::new(|| {
    Font::try_from_bytes(include_bytes!("../fonts/FuzzyBubbles-Regular.ttf")).unwrap()
});
static FONT_1: LazyLock<Font> =
    LazyLock::new(|| Font::try_from_bytes(include_bytes!("../fonts/Handlee-Regular.ttf")).unwrap());

#[inline(always)]
fn rand_num(len: usize) -> usize {
    let mut rng = thread_rng();
    rng.gen_range(0..=len)
}

/// Generate a random captcha string with a given length
#[inline]
fn rand_captcha(len: usize) -> String {
    let mut result = String::with_capacity(len);
    let seed = BASIC_CHAR.len() - 1;
    for _ in 0..len {
        let rnd = rand_num(seed);
        result.push(BASIC_CHAR[rnd])
    }
    result
}

fn get_colors(len: usize) -> Vec<Rgba<u8>> {
    let rnd = rand_num(COLORS.len());
    let mut out = Vec::with_capacity(len);
    for i in 0..len {
        let c = COLORS[(rnd + i) % COLORS.len()];
        out.push(Rgba([c.0, c.1, c.2, c.3]))
    }

    out
}

#[inline(always)]
fn get_next(min: f32, max: u32) -> f32 {
    min + rand_num(max as usize - min as usize) as f32
}

fn draw_interference_line(num: usize, image: &mut ImageBuffer<Rgba<u8>, Vec<u8>>, color: Rgba<u8>) {
    for _ in 0..num {
        let width = image.width();
        let height = image.height();
        let x1: f32 = 5.0;
        let y1 = get_next(x1, height / 2);

        let x2 = (width - 5) as f32;
        let y2 = get_next(5.0, height - 5);

        let ctrl_x = get_next((width / 6) as f32, width / 4 * 3);
        let ctrl_y = get_next(x1, height - 5);

        let ctrl_x2 = get_next((width / 12) as f32, width / 12 * 3);
        let ctrl_y2 = get_next(x1, height - 5);
        // Randomly draw bezier curves
        draw_cubic_bezier_curve_mut(
            image,
            (x1, y1),
            (x2, y2),
            (ctrl_x, ctrl_y),
            (ctrl_x2, ctrl_y2),
            color,
        );
    }
}

fn draw_interference_ellipse(
    num: usize,
    image: &mut ImageBuffer<Rgba<u8>, Vec<u8>>,
    color: Rgba<u8>,
) {
    for _ in 0..num {
        // max cycle width 20px
        let w = (10 + rand_num(10)) as i32;
        let x = rand_num((image.width() - 25) as usize) as i32;
        let y = rand_num((image.height() - 15) as usize) as i32;

        draw_filled_ellipse_mut(image, (x, y), w, w, color);
    }
}

pub struct Captcha {
    pub text: String,
    pub image: Vec<u8>,
}

pub struct CaptchaBuilder {
    length: usize,
    width: u32,
    height: u32,
    complexity: usize,
    line: bool,
    noise: bool,
    circle: bool,
    format: image::ImageFormat,
}

impl Default for CaptchaBuilder {
    fn default() -> Self {
        CaptchaBuilder {
            length: 4,
            width: 220,
            height: 70,
            complexity: 5,
            line: true,
            noise: false,
            circle: true,
            format: image::ImageFormat::Png,
        }
    }
}

impl CaptchaBuilder {
    pub fn new() -> Self {
        Self::default()
    }

    pub fn length(mut self, length: usize) -> Self {
        self.length = length;
        self
    }

    pub fn line(mut self, line: bool) -> Self {
        self.line = line;
        self
    }

    pub fn noise(mut self, noise: bool) -> Self {
        self.noise = noise;
        self
    }

    pub fn circle(mut self, circle: bool) -> Self {
        self.circle = circle;
        self
    }

    pub fn format(mut self, format: &str) -> Self {
        self.format = match format {
            "png" => image::ImageFormat::Png,
            "jpg" | "jpeg" => image::ImageFormat::Jpeg,
            "webp" => image::ImageFormat::WebP,
            _ => image::ImageFormat::Png,
        };

        self
    }

    pub fn complexity(mut self, complexity: usize) -> Self {
        self.complexity = complexity.clamp(1, 10);
        self
    }

    fn cyclic_write_character(
        &self,
        captcha: &str,
        image: &mut ImageBuffer<Rgba<u8>, Vec<u8>>,
        lines: bool,
    ) {
        let c = (image.width() - 20) / captcha.len() as u32;
        let y = image.height() / 3 - 15;

        let h = image.height() as f32;

        let scale = match captcha.len() {
            1..=3 => SCALE_LG,
            4..=5 => SCALE_MD,
            _ => SCALE_SM,
        } as f32;

        let colors = get_colors(captcha.len());
        let line_colors = get_colors(captcha.len());

        let xscale = scale - rand_num((scale * 0.2) as usize) as f32;
        let yscale = h - rand_num((h * 0.2) as usize) as f32;

        // Draw line, ellipse first as background
        if self.circle {
            (0..captcha.len()).for_each(|i| {
                let line_color = line_colors[i];

                if lines {
                    draw_interference_line(1, image, line_color);
                }
                draw_interference_ellipse(1, image, line_color);
            });
        }

        let font = match rand_num(2) {
            0 => &FONT_0,
            1 => &FONT_1,
            _ => &FONT_1,
        };

        // Draw text
        for (i, ch) in captcha.chars().enumerate() {
            let color = colors[i];

            for j in 0..(rand_num(3) + 1) as i32 {
                // Draw text again with offset
                let offset = j * (rand_num(2) as i32);
                imageproc::drawing::draw_text_mut(
                    image,
                    color,
                    10 + offset + (i as u32 * c) as i32,
                    y as i32,
                    Scale {
                        x: xscale + offset as f32,
                        y: yscale as f32,
                    },
                    font,
                    &ch.to_string(),
                );
            }
        }
    }

    pub fn build(self) -> Captcha {
        // Generate an array of captcha characters
        let text = rand_captcha(self.length);

        // Create a white background image
        let mut buf = ImageBuffer::from_fn(self.width, self.height, |_, _| {
            image::Rgba([255, 255, 255, 255])
        });

        // Loop to write the verification code string into the background image
        self.cyclic_write_character(&text, &mut buf, self.line);

        if self.noise {
            gaussian_noise_mut(
                &mut buf,
                (self.complexity - 1) as f64,
                ((10 * self.complexity) - 10) as f64,
                ((5 * self.complexity) - 5) as u64,
            );
        }

        let mut bytes: Vec<u8> = Vec::new();
        buf.write_to(&mut Cursor::new(&mut bytes), image::ImageFormat::Png)
            .expect("failed to write rucaptcha image into png");

        Captcha { text, image: bytes }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_format() {
        let mut builder = CaptchaBuilder::new();
        assert_eq!(builder.format, image::ImageFormat::Png);

        builder = builder.format("jpg");
        assert_eq!(builder.format, image::ImageFormat::Jpeg);
        builder = builder.format("jpeg");
        assert_eq!(builder.format, image::ImageFormat::Jpeg);
        builder = builder.format("webp");
        assert_eq!(builder.format, image::ImageFormat::WebP);
        builder = builder.format("png");
        assert_eq!(builder.format, image::ImageFormat::Png);
        builder = builder.format("gif");
        assert_eq!(builder.format, image::ImageFormat::Png);
    }

    #[test]
    fn test_line() {
        let mut builder = CaptchaBuilder::new();
        assert!(builder.line);

        builder = builder.line(false);
        assert!(!builder.line);
    }

    #[test]
    fn test_noise() {
        let mut builder = CaptchaBuilder::new();
        assert!(!builder.noise);

        builder = builder.noise(true);
        assert!(builder.noise);
    }

    #[test]
    fn test_difficulty() {
        let mut builder = CaptchaBuilder::new();
        assert_eq!(builder.complexity, 5);

        builder = builder.complexity(10);
        assert_eq!(builder.complexity, 10);

        builder = builder.complexity(11);
        assert_eq!(builder.complexity, 10);

        builder = builder.complexity(0);
        assert_eq!(builder.complexity, 1);
    }

    #[test]
    fn test_length() {
        let mut builder = CaptchaBuilder::new();
        assert_eq!(builder.length, 4);

        builder = builder.length(10);
        assert_eq!(builder.length, 10);
    }
}
