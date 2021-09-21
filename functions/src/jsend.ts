export function successAddSummary(value: any) {
    return successWithData(value);
}

export function successGetSummaries(values: any[]) {
    return successWithData(values);
}

export function successWithData(values: any) {
    const json = {
        status: "success",
        "data": values
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

export function error(msg: string = "Internal Server Error") {
    const json = {
        status: "error",
        "error": msg
    };
    return JSON.stringify(json);
}