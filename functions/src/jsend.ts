export function successGetSummaries(values: any[]) {
    return successWithData("certificationSummaries", values);
}

export function successGetCertifs(values: any[]) {
    return successWithData("certifications", values);
}

export function successGetUsers(values: any[]) {
    return successWithData("users", values);
}

export function successGetSkills(values: any[]) {
    return successWithData("skills", values);
}

export function successWithData(title: string, values: any[]) {
    const json = {
        status: "success",
        "data": {
            [title]: values
        }
    };
    return JSON.stringify(json);
}

export function success(msg: string) {
    const json = {
        status: "success",
        message: msg,
        "data": null
    };
    return JSON.stringify(json);
}

export function fail(title: string, values: any) {
    const json = {
        status: "fail",
        "data": {
            [title]: values
        }
    };
    return JSON.stringify(json);
}

export function error(
    msg: string = "Internal server error",
    statusCode: number = 500
) {
    const json = {
        status: "error",
        statusCode: statusCode,
        "message": msg
    };
    return JSON.stringify(json);
}