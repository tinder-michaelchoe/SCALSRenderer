import React from 'react';
export interface CladsPreviewProps {
    /** CLADS document as JSON string or object */
    document: string | object;
    /** Optional path to WASM file */
    wasmPath?: string;
    /** Callback when rendering fails */
    onError?: (error: Error) => void;
}
/**
 * React component for rendering CLADS documents using WebAssembly.
 *
 * @example
 * ```tsx
 * <CladsPreview
 *   document={cladsJson}
 *   onError={(err) => console.error(err)}
 * />
 * ```
 */
export declare function CladsPreview({ document, wasmPath, onError }: CladsPreviewProps): React.JSX.Element;
//# sourceMappingURL=CladsPreview.d.ts.map