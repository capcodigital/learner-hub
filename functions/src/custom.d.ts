import { auth } from "firebase-admin/lib/auth"

declare global {
    // Extend the Request type from Express Framework to add the user
    namespace Express {
        export interface Request {
            user?: auth.DecodedIdToken
        }
    }
}