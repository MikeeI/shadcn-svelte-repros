# `calendar-28` selects the previous month for a typed date

Official `repro` template plus the unmodified `calendar-28` block.

## Steps

```bash
pnpm install
pnpm dev
```

1. Type `August 15, 2025` into the input.
2. Open the calendar.

## Observed (`shadcn-svelte@1.7.0`, Chromium headless)

The selected day is `2025-07-15` (July 15) instead of August 15.

The block converts the input with `new CalendarDate(date.getFullYear(), date.getMonth(), date.getDate())`, but `Date.getMonth()` is 0-based and `CalendarDate` expects 1–12.
