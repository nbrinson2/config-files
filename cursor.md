# Cursor Not Recognizing All Git Repos in a Folder

Cursor (and VS Code) often fails to show all Git repos in a parent folder because of how repository auto-detection works. Cursor’s default for this is sometimes more restrictive than VS Code’s.

## Quick Fix (Most Common Cause)

1. Open the Command Palette (`Cmd/Ctrl + Shift + P`).
2. Run **Preferences: Open User Settings (JSON)**.
3. Add or update these settings:

```json
"git.autoRepositoryDetection": true,   // or "subFolders"
"git.repositoryScanMaxDepth": -1,      // unlimited depth (default is often 1)
"git.enabled": true,
"scm.alwaysShowRepositories": true
```

4. Fully quit Cursor (`Cmd/Ctrl + Q`) and reopen the folder/workspace (or run **Developer: Reload Window**).

### Setting Notes

| Value | Behavior |
|-------|----------|
| `"true"` | Scans the workspace root and subfolders |
| `"subFolders"` | Only scans subfolders |
| `"openEditors"` | Only detects a repo when you have a file from it open (common Cursor default — causes repos to appear/disappear depending on open files) |

## Other Things to Try

| Situation | What to do |
|-----------|------------|
| Nested repos inside one parent folder | Prefer the settings above. Opening the parent folder should work after the scan settings are fixed. |
| Multi-root workspace (`.code-workspace` or “Add Folder to Workspace”) | There are known Cursor bugs where repos flash then disappear, or closed repos stay hidden. See workarounds below. |
| Only one repo shows | Open a file from each missing repo (forces detection if set to `"openEditors"`). Or use **Git: Open Repository** from the Command Palette. |
| Built-in Git extension | Extensions → search `@builtin Git` → make sure it is enabled. You can also try restarting it. |
| Conflicting extensions | Launch with `cursor --disable-extensions` to test. |

## Multi-Root / Closed-Repo Bugs (Common in Cursor)

Cursor sometimes persists “closed” or “visible” repository state in a SQLite file (`state.vscdb` inside the workspace storage folder). Once a repo is closed or the visible list gets corrupted, it may not reappear even after a reload.

### Workarounds

- Remove and re-add the folders to the workspace.
- Open each repo folder individually via **File → Add Folder to Workspace** instead of a single parent folder.
- As a last resort (advanced): clear the Git-related keys in the workspace’s `state.vscdb` (paths differ by OS; search the Cursor forum for the exact SQLite commands if needed).

## Verify Detection

- Open **View → Output** and select the **Git** channel. Open the folder/workspace and look for scan messages.
- In Source Control, use the repositories view (or run **Source Control: Focus on Repositories View**).

## References

- Cursor forum: [Cursor not recognizing all of git repos within workspace](https://forum.cursor.com/t/cursor-not-recognizing-all-of-git-repos-within-workspace/145271)
- Cursor forum: [Can only access main folder in source control](https://forum.cursor.com/t/can-only-access-main-folder-in-source-control/155432)
- VS Code docs: [Working with repositories and remotes](https://code.visualstudio.com/docs/sourcecontrol/repos-remotes)
