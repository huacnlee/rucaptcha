use captcha::filters::{Cow, Dots, Grid, Noise, Wave};
use captcha::{Captcha, Geometry};
use magnus::{define_class, function, Error, Object};

// https://coolors.co/cc0b8f-7c0abe-5700c8-3c2ea4-3d56a8-3fa67e-45bb30-69d003-a0d003-d8db02
const colors: [(u8, u8, u8); 10] = [
    (204, 11, 143),
    (124, 10, 190),
    (87, 0, 200),
    (60, 46, 164),
    (61, 86, 168),
    (63, 166, 126),
    (69, 187, 48),
    (105, 208, 3),
    (160, 208, 3),
    (216, 219, 2),
];

pub fn create(style: u32, len: u32, line: bool, noise: bool) -> (String, Vec<u8>) {
    let mut c = Captcha::new();
    c.add_chars(len).view(220, 120);

    if style == 1 {
        let color = colors[rand::random::<usize>() % colors.len()];
        c.set_color([color.0, color.1, color.2]);
    }

    if line {
        c.apply_filter(Wave::new(2.0, 10.0)).apply_filter(
            Cow::new()
                .min_radius(30)
                .max_radius(50)
                .circles(1)
                .area(Geometry::new(40, 150, 50, 70)),
        );
    }

    if noise {
        c.apply_filter(Noise::new(0.4))
            .apply_filter(Grid::new(10, 10));
    }

    let chars = c.chars_as_string();
    let bytes = c.as_png().unwrap();

    (chars, bytes)
}

#[magnus::init]
fn init() -> Result<(), Error> {
    let class = define_class("RuCaptchaCore", Default::default())?;
    class.define_singleton_method("create", function!(create, 4))?;

    Ok(())
}
