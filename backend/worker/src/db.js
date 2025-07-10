export function getDB(c) {
    return c.env.DB;
}
export const DB = {
    async getUserByEmail(db, email) {
        const result = await db
            .prepare('SELECT * FROM users WHERE email = ?')
            .bind(email)
            .first();
        return result;
    },
    async createUser(db, user) {
        await db
            .prepare('INSERT INTO users (id, email, password_hash, role) VALUES (?, ?, ?, ?)')
            .bind(user.id, user.email, user.passwordHash, user.role)
            .run();
    }
};
