# Security And Privacy

Your agent config may be more sensitive than normal project documentation. It can reveal habits, clients, contact details, private paths, internal repo names, tool access patterns, and personal memory.

## Do not publish

- real contact details
- tokens, keys, auth files, cookies, or session state
- client names unless intentionally public
- private repo names
- home-directory paths that identify a real person
- tool inventories that reveal internal services
- agent memories, transcripts, logs, or conversation summaries
- local allow-lists, permissions, or security warnings
- personal routing rules for private vaults or folders

## Safe public examples

Use placeholders:

```text
you@example.com
~/Workspaces
example-org
example-project
client-a
```

Use generic folder names:

```text
personal/
company/
code-projects/
```

## Privacy review checklist

Before publishing:

- inspect every tracked file
- check for symlinks
- scan for real names, emails, phone numbers, paths, tokens, and private repo names
- confirm examples are generic
- run the audit script against fixtures and the real environment
- read the README in GitHub preview if possible

Suggested local scan:

```bash
rg -n "(@|token|secret|api[_-]?key|client-|key block marker)" .
```

This scan is not enough on its own. It is a backstop before a human review.

## Public repo policy

This repo intentionally does not include an automatic migration script. A script that rewires global agent config can break someone else's setup. The v1 tool only inspects and reports.
