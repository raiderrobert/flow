---
name: core-browser
# Internal tool - no description to prevent auto-triggering
# Used by: rust-learner agents for pre-computed selectors and browser automation
---

# Browser Automation

Browser automation combining pre-computed action selectors (actionbook) with direct browser control (agent-browser).

## Priority Order

For fetching information:
1. **actionbook MCP** - Pre-computed selectors for known sites
2. **agent-browser CLI** - Direct browser automation
3. **WebFetch** - Last resort fallback

## Actionbook

Pre-computed action manuals for browser automation. Agents receive structured page information instead of parsing entire HTML.

### MCP Tools

- `search_actions` - Search by keyword. Returns: URL-based action IDs, content previews, relevance scores
- `get_action_by_id` - Get full action details. Returns: action content, page element selectors (CSS/XPath), element types, allowed methods (click, type, extract), document metadata

### Parameters

**search_actions**:
- `query` (required): Search keyword (e.g., "airbnb search", "google login")
- `type`: `vector` | `fulltext` | `hybrid` (default)
- `limit`: Max results (default: 5)
- `sourceIds`: Filter by source IDs (comma-separated)
- `minScore`: Minimum relevance score (0-1)

**get_action_by_id**:
- `id` (required): URL-based action ID (e.g., `example.com/page`)

### Example Response

```json
{
  "title": "Airbnb Search",
  "url": "www.airbnb.com/search",
  "elements": [
    {
      "name": "location_input",
      "selector": "input[data-testid='structured-search-input-field-query']",
      "type": "textbox",
      "methods": ["type", "fill"]
    }
  ]
}
```

## agent-browser CLI

### Quick Start

```bash
agent-browser open <url>        # Navigate to page
agent-browser snapshot -i       # Get interactive elements with refs
agent-browser click @e1         # Click element by ref
agent-browser fill @e2 "text"   # Fill input by ref
agent-browser close             # Close browser
```

### Core Workflow

1. Navigate: `agent-browser open <url>`
2. Snapshot: `agent-browser snapshot -i` (returns elements with refs like `@e1`, `@e2`)
3. Interact using refs from the snapshot
4. Re-snapshot after navigation or significant DOM changes

### Commands

**Navigation:**
```bash
agent-browser open <url>      # Navigate to URL
agent-browser back            # Go back
agent-browser forward         # Go forward
agent-browser reload          # Reload page
agent-browser close           # Close browser
```

**Snapshot (page analysis):**
```bash
agent-browser snapshot        # Full accessibility tree
agent-browser snapshot -i     # Interactive elements only (recommended)
agent-browser snapshot -c     # Compact output
agent-browser snapshot -d 3   # Limit depth to 3
```

**Interactions (use @refs from snapshot):**
```bash
agent-browser click @e1           # Click
agent-browser dblclick @e1        # Double-click
agent-browser fill @e2 "text"     # Clear and type
agent-browser type @e2 "text"     # Type without clearing
agent-browser press Enter         # Press key
agent-browser press Control+a     # Key combination
agent-browser hover @e1           # Hover
agent-browser check @e1           # Check checkbox
agent-browser uncheck @e1         # Uncheck checkbox
agent-browser select @e1 "value"  # Select dropdown
agent-browser scroll down 500     # Scroll page
agent-browser scrollintoview @e1  # Scroll element into view
```

**Get information:**
```bash
agent-browser get text @e1        # Get element text
agent-browser get value @e1       # Get input value
agent-browser get title           # Get page title
agent-browser get url             # Get current URL
```

**Screenshots:**
```bash
agent-browser screenshot          # Screenshot to stdout
agent-browser screenshot path.png # Save to file
agent-browser screenshot --full   # Full page
```

**Wait:**
```bash
agent-browser wait @e1                     # Wait for element
agent-browser wait 2000                    # Wait milliseconds
agent-browser wait --text "Success"        # Wait for text
agent-browser wait --load networkidle      # Wait for network idle
```

**Semantic locators (alternative to refs):**
```bash
agent-browser find role button click --name "Submit"
agent-browser find text "Sign In" click
agent-browser find label "Email" fill "user@test.com"
```

## Example: Form Submission

```bash
agent-browser open https://example.com/form
agent-browser snapshot -i
# Output shows: textbox "Email" [ref=e1], textbox "Password" [ref=e2], button "Submit" [ref=e3]

agent-browser fill @e1 "user@example.com"
agent-browser fill @e2 "password123"
agent-browser click @e3
agent-browser wait --load networkidle
agent-browser snapshot -i  # Check result
```
