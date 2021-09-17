/* eslint-disable require-jsdoc */
import * as functions from "firebase-functions";
import { logger } from "firebase-functions";
import * as jsend from "../jsend";
import * as certRepo from "./certification_summary_repository";

export async function getAllCertificationSummaries(res: functions.Response) {
    try {
        const items = await certRepo.getAlCertificationSummaries();
        res.setHeader('Content-Type', 'application/json');
        res.statusCode = 200;
        res.send(jsend.successGetCertifs(items));
    } catch (e) {
        logger.log(e)
        res.statusCode = 500;
        res.send(jsend.error());
    }
}

export async function addCertificationSummary(
    summary: any,
    res: functions.Response) {
    try {
        const items = await certRepo.getAlCertificationSummaries();
        res.setHeader('Content-Type', 'application/json');
        res.statusCode = 200;
        res.send(jsend.successGetCertifs(items));
    } catch (e) {
        logger.log(e)
        res.statusCode = 500;
        res.send(jsend.error());
    }
}



