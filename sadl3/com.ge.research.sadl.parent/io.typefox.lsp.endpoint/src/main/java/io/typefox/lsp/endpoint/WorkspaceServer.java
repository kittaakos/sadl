package io.typefox.lsp.endpoint;

import java.util.concurrent.CompletableFuture;

import org.eclipse.lsp4j.jsonrpc.services.JsonRequest;
import org.eclipse.lsp4j.jsonrpc.services.JsonSegment;

@JsonSegment("workspace")
public interface WorkspaceServer {

	/**
	 * <p>
	 * Computes a file state for the given URI and its children.
	 * </p>
	 * 
	 * @return
	 *         <ol>
	 *         <li>{@code null} if a file does not exist for
	 *         {@link ResolveFileParams#uri params.uri}</li>
	 *         <li>otherwise a file if {@link ResolveFileParams#uri params.uri}
	 *         corresponds to an existing file</li>
	 *         <li>otherwise:
	 *         <ol>
	 *         <li>a directory if {@link ResolveFileParams#maxDepth
	 *         params.maxDepth} = 0;<br>
	 *         a directory is not resolved</li>
	 *         <li>a directory and its children if
	 *         {@link ResolveFileParams#maxDepth params.maxDepth} = 1;<br>
	 *         child directories are not resolved</li>
	 *         <li>a directory and its children if
	 *         {@link ResolveFileParams#maxDepth params.maxDepth} = N where N >
	 *         1;<br>
	 *         child directories are resolved with
	 *         {@link ResolveFileParams#maxDepth params.maxDepth} = N - 1</li>
	 *         </ol>
	 *         </ol>
	 */
	@JsonRequest
	CompletableFuture<File> resolveFile(ResolveFileParams params);

	/**
	 * <p>
	 * Computes a file content for the given URI.
	 * </p>
	 * 
	 * @return {@code null} if a file does exist for
	 *         {@link ResolveFileContentParams#uri params.uri};
	 *         otherwise a file content
	 */
	@JsonRequest
	CompletableFuture<FileContent> resolveFileContent(ResolveFileContentParams params);

}