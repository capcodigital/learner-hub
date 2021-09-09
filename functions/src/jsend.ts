

export function successGetItems(title: string, values: any[]) {
    const json = {
        status: "success",
        "data": {
            [title]: values
        }
    };
    return JSON.stringify(json);
}

export function success() {
    const json = {
        status: "success",
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
    msg: string
) {
    const json = {
        status: "error",
        "message": msg
    };
    return JSON.stringify(json);
}