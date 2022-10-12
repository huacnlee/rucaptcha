use captcha::filters::{Cow, Dots, Noise, Wave};
use captcha::{Captcha, Geometry};
use magnus::{define_class, function, Error, Object};

pub fn create(style: u32, len: u32, line: bool, noise: bool) -> (String, Vec<u8>) {
    let mut c = Captcha::new();
    c.add_chars(len).view(220, 120);

    if line {
        c.apply_filter(
            Cow::new()
                .min_radius(40)
                .max_radius(50)
                .circles(1)
                .area(Geometry::new(40, 150, 50, 70)),
        );
    }

    if noise {
        c.apply_filter(Noise::new(0.2))
            .apply_filter(Wave::new(2.0, 12.0))
            .apply_filter(Dots::new(2));
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
