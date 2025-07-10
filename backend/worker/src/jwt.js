// backend/worker/src/jwt.ts
import { HmacSHA256 } from './crypto';
function encodeBase64Url(input) {
    return btoa(String.fromCharCode(...input))
        .replace(/\+/g, '-')
        .replace(/\//g, '_')
        .replace(/=+$/, '');
}
function decodeBase64Url(base64url) {
    const base64 = base64url
        .replace(/-/g, '+')
        .replace(/_/g, '/')
        .padEnd(base64url.length + (4 - base64url.length % 4) % 4, '=');
    const binary = atob(base64);
    return new Uint8Array([...binary].map((char) => char.charCodeAt(0)));
}
export async function signJWT(payload, secret) {
    const header = {
        alg: 'HS256',
        typ: 'JWT'
    };
    const encoder = new TextEncoder();
    const headerEncoded = encodeBase64Url(encoder.encode(JSON.stringify(header)));
    const payloadEncoded = encodeBase64Url(encoder.encode(JSON.stringify(payload)));
    const data = `${headerEncoded}.${payloadEncoded}`;
    const signature = await HmacSHA256(data, secret);
    return `${data}.${signature}`;
}
export async function verifyJWT(token, secret) {
    try {
        const [headerEncoded, payloadEncoded, signature] = token.split('.');
        const data = `${headerEncoded}.${payloadEncoded}`;
        const expectedSignature = await HmacSHA256(data, secret);
        return expectedSignature === signature;
    }
    catch (err) {
        return false;
    }
}
export function decodeJWT(token) {
    const [headerEncoded, payloadEncoded] = token.split('.');
    const json = new TextDecoder().decode(decodeBase64Url(payloadEncoded));
    return JSON.parse(json);
}
export { encodeBase64Url, decodeBase64Url };
