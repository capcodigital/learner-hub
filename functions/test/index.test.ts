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

describe("Catalog Url", () => {
    it("should return url error if certification id is valid", async () => {
     (admin.auth as jest.Mocked<any>).mockReturnValueOnce({
                verifyIdToken: jest.fn()
            });
        const res = await request(app)
            .get(`/catalog/1`)
             .set('Authorization', 'Bearer validToken');
        expect(res.text)
        .toEqual("https://ilabs-capco.atlassian.net/wiki/spaces/BPG/pages/2468773934/Security+Udemy+Training");
    });

    it("should return empty URL if certification id not valid", async () => {
     (admin.auth as jest.Mocked<any>).mockReturnValueOnce({
                verifyIdToken: jest.fn()
            });
        const res = await request(app)
            .get(`/catalog/10`)
             .set('Authorization', 'Bearer validToken');
        expect(res.text).toEqual("");
    });
});