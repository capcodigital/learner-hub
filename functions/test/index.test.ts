import request from 'supertest';
import { app } from './../src/index';

describe("Post Endpoints", () => {
    it("should fetch a single post", async () => {
        const res = await request(app).get(`/hello`);
        expect(res.statusCode).toEqual(401);
    });
});