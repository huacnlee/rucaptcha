use image::{ImageBuffer, Rgba};
use rand::{thread_rng, Rng};
use rusttype::{Font, Scale};
use std::io::Cursor;

static BASIC_CHAR: [char; 54] = [
    '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'M',
    'N', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g',
    'h', 'j', 'k', 'm', 'n', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
];

static FONT_BYTES1: &[u8; 145008] = include_bytes!("../fonts/FuzzyBubbles-Regular.ttf");
static FONT_BYTES2: &[u8; 37792] = include_bytes!("../fonts/Handlee-Regular.ttf");

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

fn rand_num(len: usize) -> usize {
    let mut rng = thread_rng();
    rng.gen_range(0..=len)
}

fn get_captcha(len: usize) -> Vec<String> {
    let mut res = vec![];
    for _ in 0..len {
        let rnd = rand_num(53);
        res.push(BASIC_CHAR[rnd].to_string())
    }
    res
}

#[allow(unused)]
fn get_color() -> Rgba<u8> {
    let rnd = rand_num(COLORS.len() - 1);
    let c = COLORS[rnd];
    Rgba([c.0, c.1, c.2, c.3])
}

fn get_colors(num: usize) -> Vec<Rgba<u8>> {
    let rnd = rand_num(COLORS.len());
    let mut out = vec![];
    for i in 0..num {
        let c = COLORS[(rnd + i) % COLORS.len()];
        out.push(Rgba([c.0, c.1, c.2, c.3]))
    }

    out
}

fn get_next(min: f32, max: u32) -> f32 {
    min + rand_num(max as usize - min as usize) as f32
}

fn get_font() -> Font<'static> {
    match rand_num(2) {
        0 => Font::try_from_bytes(FONT_BYTES1).unwrap(),
        1 => Font::try_from_bytes(FONT_BYTES2).unwrap(),
        _ => Font::try_from_bytes(FONT_BYTES1).unwrap(),
    }
}

fn get_image(width: usize, height: usize) -> ImageBuffer<Rgba<u8>, Vec<u8>> {
    ImageBuffer::from_fn(width as u32, height as u32, |_, _| {
        image::Rgba([255, 255, 255, 255])
    })
}

fn cyclic_write_character(res: &[String], image: &mut ImageBuffer<Rgba<u8>, Vec<u8>>, lines: bool) {
    let c = (image.width() - 20) / res.len() as u32;
    let y = image.height() / 3 - 15;

    let h = image.height() as f32;

    let scale = match res.len() {
        1..=3 => SCALE_LG,
        4..=5 => SCALE_MD,
        _ => SCALE_SM,
    } as f32;

    let colors = get_colors(res.len());
    let line_colors = get_colors(res.len());

    let xscale = scale - rand_num((scale * 0.2) as usize) as f32;
    let yscale = h as f32 - rand_num((h * 0.2) as usize) as f32;

    // Draw line, ellipse first as background
    for (i, _) in res.iter().enumerate() {
        let line_color = line_colors[i];

        if lines {
            draw_interference_line(1, image, line_color);
        }
        draw_interference_ellipse(1, image, line_color);
    }

    // Draw text
    for (i, _) in res.iter().enumerate() {
        let text = &res[i];

        let color = colors[i];
        let font = get_font();

        for j in 0..(rand_num(3) + 1) as i32 {
            // Draw text again with offset
            let offset = j * (rand_num(2) as i32);
            imageproc::drawing::draw_text_mut(
                image,
                color,
                10 + offset + (i as u32 * c) as i32,
                y as i32 as i32,
                Scale {
                    x: xscale + offset as f32,
                    y: yscale as f32,
                },
                &font,
                text,
            );
        }
    }
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
        imageproc::drawing::draw_cubic_bezier_curve_mut(
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

        imageproc::drawing::draw_filled_ellipse_mut(image, (x, y), w, w, color);
    }
}

pub struct Captcha {
    pub text: String,
    pub image: Vec<u8>,
}

pub struct CaptchaBuilder {
    length: usize,
    width: usize,
    height: usize,
    complexity: usize,
    line: bool,
    noise: bool,
    format: image::ImageFormat,
}

impl CaptchaBuilder {
    pub fn new() -> Self {
        CaptchaBuilder {
            length: 4,
            width: 220,
            height: 70,
            complexity: 5,
            line: true,
            noise: false,
            format: image::ImageFormat::Png,
        }
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
        let mut complexity = complexity;
        if complexity > 10 {
            complexity = 10;
        }
        if complexity < 1 {
            complexity = 1;
        }
        self.complexity = complexity;
        self
    }

    pub fn build(self) -> Captcha {
        // Generate an array of captcha characters
        let res = get_captcha(self.length);

        let text = res.join("");

        // Create a white background image
        let mut image = get_image(self.width, self.height);

        // Loop to write the verification code string into the background image
        cyclic_write_character(&res, &mut image, self.line);

        if self.noise {
            imageproc::noise::gaussian_noise_mut(
                &mut image,
                (self.complexity - 1) as f64,
                ((10 * self.complexity) - 10) as f64,
                ((5 * self.complexity) - 5) as u64,
            );
        }

        let mut bytes: Vec<u8> = Vec::new();
        image
            .write_to(&mut Cursor::new(&mut bytes), image::ImageFormat::Png)
            .unwrap();

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
