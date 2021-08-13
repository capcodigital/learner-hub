import request from 'supertest';
import { app } from './../src/index';
import admin from 'firebase-admin';

jest.mock('firebase-admin', () => ({
    auth: jest.fn(),
    initializeApp: jest.fn()
}));

describe("Auth Middleware", () => {
    it("should return 401 error if not token pass", async () => {
        const res = await request(app)
            .get(`/hello`);
        expect(res.statusCode).toEqual(401);
    });

    it("should return 401 error if token is not valid", async () => {
        const res = await request(app)
            .get(`/hello`)
            .set('Authorization', 'Bearer invalidFakeToken');
        expect(res.statusCode).toEqual(401);
    });

    it("should return no error if token is valid", async () => {
        (admin.auth as jest.Mocked<any>).mockReturnValueOnce({
            verifyIdToken: jest.fn()
        });

        const res = await request(app)
            .get(`/hello`)
            .set('Authorization', 'Bearer validToken');
        expect(res.statusCode).toEqual(200);
    });
});