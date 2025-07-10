// backend/worker/src/crypto.ts
// Encode text into Uint8Array
function toUint8Array(str) {
    return new TextEncoder().encode(str);
}
// Convert Uint8Array to base64url string
function encodeBase64Url(input) {
    return btoa(String.fromCharCode(...input))
        .replace(/\+/g, '-')
        .replace(/\//g, '_')
        .replace(/=+$/, '');
}
// HMAC SHA256 implementation using Web Crypto API
export async function HmacSHA256(data, secret) {
    const key = await crypto.subtle.importKey('raw', toUint8Array(secret), { name: 'HMAC', hash: 'SHA-256' }, false, ['sign']);
    const signature = await crypto.subtle.sign('HMAC', key, toUint8Array(data));
    return encodeBase64Url(new Uint8Array(signature));
}
// Generate salt (16 bytes)
function generateSalt() {
    const array = new Uint8Array(16);
    crypto.getRandomValues(array);
    return encodeBase64Url(array);
}
// Hash password with salt
export async function hashPassword(password) {
    const salt = generateSalt();
    const hash = await HmacSHA256(password, salt);
    return `${salt}.${hash}`;
}
// Verify password by re-hashing with original salt
export async function verifyPassword(password, storedHash) {
    const [salt, originalHash] = storedHash.split('.');
    const hash = await HmacSHA256(password, salt);
    return hash === originalHash;
}
