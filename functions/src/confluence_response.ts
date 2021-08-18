interface ConfluenceResponse {
    body: Body;
}

interface Body {
    export_view: ExportView;
}

interface ExportView {
    value: string;
}