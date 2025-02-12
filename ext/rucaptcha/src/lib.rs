use magnus::{define_class, function, Error, Object};

mod captcha;

pub fn create(
    len: usize,
    difficulty: usize,
    line: bool,
    noise: bool,
    circle: bool,
    format: String,
) -> (String, Vec<u8>) {
    let c = captcha::CaptchaBuilder::new();
    let out = c
        .complexity(difficulty)
        .length(len)
        .line(line)
        .noise(noise)
        .circle(circle)
        .format(&format)
        .build();

    (out.text, out.image)
}

#[magnus::init]
fn init() -> Result<(), Error> {
    let class = define_class("RuCaptchaCore", magnus::class::object())?;
    class.define_singleton_method("create", function!(create, 6))?;

    Ok(())
}
