import request from 'supertest';
import { app } from './../src/index';

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
});