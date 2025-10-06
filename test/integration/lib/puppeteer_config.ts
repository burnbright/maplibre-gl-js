import puppeteer, {type Browser} from 'puppeteer';

export async function launchPuppeteer(headless = true): Promise<Browser> {
    return puppeteer.launch({
        headless,
        args: [
            '--no-sandbox',
            '--disable-setuid-sandbox',
            '--disable-gpu',
            '--enable-features=AllowSwiftShaderFallback,AllowSoftwareGLFallbackDueToCrashes',
            '--enable-unsafe-swiftshader'
        ],
    });
}