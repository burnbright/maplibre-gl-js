import puppeteer, {type Browser} from 'puppeteer';

export async function launchPuppeteer(headless = true): Promise<Browser> {
    return puppeteer.launch({
        headless,
        executablePath: process.env.PUPPETEER_EXECUTABLE_PATH || '/usr/bin/google-chrome',
        args: [
            '--disable-gpu',
            '--enable-features=AllowSwiftShaderFallback,AllowSoftwareGLFallbackDueToCrashes',
            '--enable-unsafe-swiftshader'
        ],
    });
}