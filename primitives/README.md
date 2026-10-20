# `@shadcn-svelte/primitives` reproductions

Each section is a failing Vitest browser test for `packages/primitives`.
Run it with `pnpm -F @shadcn-svelte/primitives test:browser <file>` after adding the test.
The tests were observed failing in Chromium on `huntabyte/shadcn-svelte@97fdb93` with Node 26.
The `+page.svelte` examples are convenience pages for the StackBlitz template; only the tests were run.

## MessageScroller: scroll-to-end button stays inactive after `autoScroll` is switched off

Source: `huntabyte/shadcn-svelte@97fdb93`; add the test below to `packages/primitives/src/lib/message-scroller/message-scroller.browser.test.ts`.
It uses that file’s existing `renderThread`, `createItems`, `getViewport`, and `getDistanceToBottom` helpers.

```ts
test("enables the scroll-to-end button after disabling autoScroll and appending", async () => {
	const initial = createItems(8);

	await renderThread({ autoScroll: true, items: initial, showButton: true });

	const viewport = getViewport();
	const button = document.querySelector("button") as HTMLButtonElement;

	expect(getDistanceToBottom(viewport)).toBeLessThanOrEqual(1);
	expect(button.dataset.active).toBe("false");

	updateThread({ autoScroll: false, items: initial, showButton: true });
	await settle();

	updateThread({ autoScroll: false, items: [...initial, { id: "new" }], showButton: true });
	await settle();

	expect(getDistanceToBottom(viewport)).toBeGreaterThan(0);
	expect(button.dataset.active).toBe("true");
});
```

Run: `pnpm -F @shadcn-svelte/primitives test:browser src/lib/message-scroller/message-scroller.browser.test.ts src/lib/questionnaire/questionnaire.browser.test.ts`.

Observed: Chromium failure: `expect(button.dataset.active).toBe("true")` expected `"true"`, received `"false"`.
The preceding `getDistanceToBottom(viewport) > 0` assertion passed, so the viewport had content below it while the button remained inactive.
In the combined run, the message-scroller file had 3 failing reproductions; questionnaire passed.
Overall: `Test Files 1 failed | 1 passed (2)`; `Tests 3 failed | 45 passed (48)`.

Expected: After `autoScroll` changes from true to false at the bottom, appending content should leave the viewport free-scrolling and mark the end as reachable; the scroll-to-end button should expose `data-active="true"`.

Example page:

```svelte
<script lang="ts">
	import { MessageScroller } from "@shadcn-svelte/primitives/message-scroller";

	let autoScroll = $state(true);
	let messages = $state(Array.from({ length: 8 }, (_, index) => ({ id: `message-${index}` })));

	function disableAutoScroll() {
		autoScroll = false;
	}

	function appendMessage() {
		messages = [...messages, { id: `message-${messages.length}` }];
	}
</script>

<button onclick={disableAutoScroll}>Disable autoScroll</button>
<button onclick={appendMessage}>Append message</button>

<MessageScroller.Provider {autoScroll} defaultScrollPosition="end">
	<MessageScroller.Root>
		<MessageScroller.Viewport aria-label="Messages" style="height: 200px; overflow-y: auto;">
			<MessageScroller.Content style="display: flex; flex-direction: column;">
				{#each messages as message (message.id)}
					<MessageScroller.Item messageId={message.id} style="height: 80px; flex: none;">
						{message.id}
					</MessageScroller.Item>
				{/each}
			</MessageScroller.Content>
		</MessageScroller.Viewport>
		<MessageScroller.Button>Scroll to end</MessageScroller.Button>
	</MessageScroller.Root>
</MessageScroller.Provider>
```

## MessageScroller: replacing a keyed row jumps to an old initial `scrollAnchor`

Source: `huntabyte/shadcn-svelte@97fdb93`; add the test below to `packages/primitives/src/lib/message-scroller/message-scroller.browser.test.ts`.
It uses that file’s existing `renderThread`, `getViewport`, `getScrollTop`, and `settle` helpers.

```ts
test("does not jump to an old anchor when replacing a keyed row", async () => {
	const initial = Array.from({ length: 8 }, (_, index) => ({
		id: `m${index}`,
		scrollAnchor: true,
	}));

	await renderThread({ defaultScrollPosition: "end", items: initial });

	const viewport = getViewport();
	const originalScrollTop = getScrollTop(viewport);

	expect(originalScrollTop).toBeGreaterThan(0);

	updateThread({
		defaultScrollPosition: "end",
		items: initial.map((item, index) =>
			index === 3 ? { id: "replacement", scrollAnchor: true } : item
		),
	});
	await settle();

	expect(getScrollTop(viewport)).toBe(originalScrollTop);
});
```

Run: `pnpm -F @shadcn-svelte/primitives test:browser src/lib/message-scroller/message-scroller.browser.test.ts src/lib/questionnaire/questionnaire.browser.test.ts`.

Observed: Chromium failure: `getScrollTop(viewport)` expected the original `440`, received `0` after replacing keyed row 3.
Initial items had eight `scrollAnchor` rows; item count stayed constant.
This confirms the viewport jumps to an older unhandled initial anchor during the equal-count update.

Expected: A keyed replacement that preserves item count should not be treated as a new transcript turn or move the viewport away from its existing bottom position.

Example page:

```svelte
<script lang="ts">
	import { MessageScroller } from "@shadcn-svelte/primitives/message-scroller";

	let nextReplacementId = 0;
	let messages = $state(
		Array.from({ length: 8 }, (_, index) => ({ id: `message-${index}`, scrollAnchor: true }))
	);

	function replaceMiddleRow() {
		const replacementId = `replacement-${++nextReplacementId}`;
		messages = messages.map((message, index) =>
			index === 3 ? { id: replacementId, scrollAnchor: true } : message
		);
	}
</script>

<button onclick={replaceMiddleRow}>Replace keyed row</button>

<MessageScroller.Provider defaultScrollPosition="end">
	<MessageScroller.Root>
		<MessageScroller.Viewport aria-label="Messages" style="height: 200px; overflow-y: auto;">
			<MessageScroller.Content style="display: flex; flex-direction: column;">
				{#each messages as message (message.id)}
					<MessageScroller.Item
						messageId={message.id}
						scrollAnchor={message.scrollAnchor}
						style="height: 80px; flex: none;"
					>
						{message.id}
					</MessageScroller.Item>
				{/each}
			</MessageScroller.Content>
		</MessageScroller.Viewport>
		<MessageScroller.Button>Scroll to end</MessageScroller.Button>
	</MessageScroller.Root>
</MessageScroller.Provider>
```

## MessageScroller: scrollbar drag (scroll event only) does not release the anchor hold

Source: `huntabyte/shadcn-svelte@97fdb93`; add the test below to `packages/primitives/src/lib/message-scroller/message-scroller.browser.test.ts`.
It uses that file’s existing `renderThread`, `updateThread`, `getViewport`, `getScrollTop`, `viewportOffsetOf`, and `settle` helpers.

```ts
test("releases message anchoring when scrolling without a wheel gesture", async () => {
	const initial = Array.from({ length: 8 }, (_, index) => ({
		id: `m${index}`,
		height: 120,
	}));

	await renderThread({ items: initial });

	updateThread({
		items: [...initial, { id: "turn", height: 80, scrollAnchor: true }, { id: "reply", height: 40 }],
	});
	await settle();

	const viewport = getViewport();
	const turnScrollTop = getScrollTop(viewport);

	expect(viewportOffsetOf("turn", viewport)).toBe(64);

	viewport.scrollTop = turnScrollTop - 64;
	viewport.dispatchEvent(new Event("scroll", { bubbles: true }));
	await settle();

	const draggedScrollTop = getScrollTop(viewport);

	expect(draggedScrollTop).toBeLessThan(turnScrollTop);

	updateThread({
		items: [
			...initial,
			{ id: "turn", height: 80, scrollAnchor: true },
			{ id: "reply", height: 240 },
		],
	});
	await settle();
	await settle();

	expect(getScrollTop(viewport)).toBe(draggedScrollTop);
});
```

Run: `pnpm -F @shadcn-svelte/primitives test:browser src/lib/message-scroller/message-scroller.browser.test.ts src/lib/questionnaire/questionnaire.browser.test.ts`.

Observed: Chromium failure after content resize: the test expected the dragged position `832`, but observed `896` (`expected 832 to be 896`).
The anchor was initially at viewport offset 64; setting `scrollTop` lower and dispatching only `scroll` moved from 896 to 832.
Growing the reply restored the old position to 896.

Expected: Dragging the scrollbar away from an anchored turn should release the anchor hold.
Later content growth should not restore the old scroll position; the documentation explicitly says scrollbar dragging releases anchoring.

Example page:

```svelte
<script lang="ts">
	import { MessageScroller } from "@shadcn-svelte/primitives/message-scroller";

	const previousMessages = Array.from({ length: 8 }, (_, index) => ({
		id: `message-${index}`,
	}));
	let replyHeight = $state(40);
</script>

<p>Drag the viewport scrollbar upward, then grow the reply.</p>
<button onclick={() => (replyHeight = 240)}>Grow reply</button>

<MessageScroller.Provider defaultScrollPosition="last-anchor">
	<MessageScroller.Root>
		<MessageScroller.Viewport aria-label="Messages" style="height: 200px; overflow-y: auto;">
			<MessageScroller.Content style="display: flex; flex-direction: column;">
				{#each previousMessages as message (message.id)}
					<MessageScroller.Item messageId={message.id} style="height: 120px; flex: none;">
						{message.id}
					</MessageScroller.Item>
				{/each}
				<MessageScroller.Item
					messageId="turn"
					scrollAnchor
					style="height: 80px; flex: none;"
				>
					Anchored turn
				</MessageScroller.Item>
				<MessageScroller.Item messageId="reply" style="height: {replyHeight}px; flex: none;">
					Streaming reply
				</MessageScroller.Item>
			</MessageScroller.Content>
		</MessageScroller.Viewport>
	</MessageScroller.Root>
</MessageScroller.Provider>
```

## Questionnaire: skipped uncontrolled item keeps its text and `data-filled` but is dropped from FormData

Source: `huntabyte/shadcn-svelte@97fdb93`.
Add this scenario before the final `{/if}` in `packages/primitives/src/lib/questionnaire/fixtures/questionnaire-cases.svelte`:

```svelte
{:else if model.scenario === "uncontrolled-skip"}
	<Questionnaire.Root data-testid="root" defaultItem="start">
		<TestItem required name="start" />
		<Questionnaire.Item data-testid="optional" name="optional">
			<Questionnaire.Title>Optional</Questionnaire.Title>
			<Questionnaire.Input data-testid="optional-input" aria-label="Optional response" />
		</Questionnaire.Item>
		<TestItem required name="last" />
		<Questionnaire.Previous data-testid="previous" />
		<Questionnaire.Skip data-testid="skip" />
		<Questionnaire.Next data-testid="next" />
	</Questionnaire.Root>
```

Add this test to `packages/primitives/src/lib/questionnaire/questionnaire.browser.test.ts`:

```ts
test("retains an uncontrolled optional input draft after Skip detaches it from FormData", async () => {
	await renderBrowser("uncontrolled-skip");

	await userEvent.click(choiceInput("start-choice"));
	await userEvent.click(requiredElement('[data-testid="next"]'));
	await settle();

	const input = requiredElement<HTMLInputElement>('[data-testid="optional-input"]');
	const root = form();

	await userEvent.type(input, "Draft");
	await settle();

	expect(input.value).toBe("Draft");
	expect(input.hasAttribute("data-filled")).toBe(true);
	expect(new FormData(root).get("optional")).toBe("Draft");

	await userEvent.click(requiredElement('[data-testid="skip"]'));
	await settle();
	await userEvent.click(requiredElement('[data-testid="previous"]'));
	await settle();

	expect(requiredElement('[data-testid="optional"]').hasAttribute("data-active")).toBe(true);
	expect(requiredElement('[data-testid="optional"]').getAttribute("data-status")).toBe("skipped");
	expect(input.value).toBe("Draft");
	expect(input.hasAttribute("data-filled")).toBe(true);
	expect(input.hasAttribute("name")).toBe(false);
	expect(input.getAttribute("form")).toBe("");
	expect(new FormData(root).get("optional")).toBeNull();
});
```

Focused run: `pnpm -F @shadcn-svelte/primitives test:browser src/lib/questionnaire/questionnaire.browser.test.ts --testNamePattern="retains an uncontrolled optional input draft after Skip detaches it from FormData"`.

Observed: The focused Chromium test passed: `Test Files 1 passed (1)`; `Tests 1 passed | 23 skipped (24)`.
Assertions establish that after typing and Skip→Previous the active item reports `data-status="skipped"`, the uncontrolled input still has value `Draft` and `data-filled`, but has no `name`, `form=""`, and `FormData.get("optional") === null`.

Expected: If Skip is meant to discard an optional answer, returning to that item should not present a retained filled value as though it were an answer.
The test confirms the exact behavior, but does not establish that preserving a draft is unintended.

Example page:

```svelte
<script lang="ts">
	import { Questionnaire } from "@shadcn-svelte/primitives/questionnaire";

	let snapshot = $state("Select Continue, fill the optional response, skip, then go back.");

	function inspectState() {
		const input = document.querySelector<HTMLInputElement>('[aria-label="Optional response"]');
		const form = input?.closest("form");
		snapshot = JSON.stringify({
			value: input?.value,
			dataFilled: input?.hasAttribute("data-filled"),
			formDataOptional: form ? new FormData(form).get("optional") : null,
		});
	}
</script>

<p>{snapshot}</p>
<button type="button" onclick={inspectState}>Inspect current state</button>

<Questionnaire.Root defaultItem="start">
	<Questionnaire.Item name="start" required>
		<Questionnaire.Title>Start</Questionnaire.Title>
		<Questionnaire.Choice value="continue">
			<Questionnaire.ChoiceInput />
			<Questionnaire.ChoiceLabel>Continue</Questionnaire.ChoiceLabel>
		</Questionnaire.Choice>
	</Questionnaire.Item>

	<Questionnaire.Item name="optional">
		<Questionnaire.Title>Optional response</Questionnaire.Title>
		<Questionnaire.Input aria-label="Optional response" />
	</Questionnaire.Item>

	<Questionnaire.Item name="last" required>
		<Questionnaire.Title>Last question</Questionnaire.Title>
		<Questionnaire.Choice value="done">
			<Questionnaire.ChoiceInput />
			<Questionnaire.ChoiceLabel>Done</Questionnaire.ChoiceLabel>
		</Questionnaire.Choice>
	</Questionnaire.Item>

	<Questionnaire.Previous />
	<Questionnaire.Skip>Skip</Questionnaire.Skip>
	<Questionnaire.Next />
	<Questionnaire.Submit />
</Questionnaire.Root>
```
