/* eslint-disable require-jsdoc */
import * as functions from "firebase-functions";
import * as jsend from "../jsend";
import * as userCertRepo from "./user_certifications_repository";

export async function addUserCertification(
    summary: any,
    res: functions.Response) {
    try {
        const item = await userCertRepo.insert(summary);
        functions.logger.log(item);
        res.setHeader('Content-Type', 'application/json');
        res.statusCode = 201;
        res.send(jsend.successWithData(item));
    } catch (e) {
        functions.logger.log(e);
        res.statusCode = 500;
        res.send(jsend.error());
    }
}

/*
export async function getAllCertifications(res: functions.Response) {
    try {
        const items = await userCertRepo.
            res.setHeader('Content-Type', 'application/json');
        res.statusCode = 200;
        res.send(jsend.successWithData(items));
    } catch (e) {
        logger.log(e);
        res.statusCode = 500;
        res.send(jsend.error());
    }
}

export async function getCertificationSummary(
    id: string,
    res: functions.Response) {
    try {
        const summary = await userCertRepo.get(id);
        res.setHeader('Content-Type', 'application/json');
        res.statusCode = 200;
        res.send(jsend.successWithData([summary]));
    } catch (e) {
        logger.log(e);
        if (e instanceof userCertRepo.CertificationNotFoundError) {
            res.statusCode = 404;
            res.send(jsend.error("Certification not found"));
        } else {
            res.statusCode = 500;
            res.send(jsend.error());
        }
    }
}
*/

