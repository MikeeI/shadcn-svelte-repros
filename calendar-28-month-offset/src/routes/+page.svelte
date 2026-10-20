<script lang="ts">
	// Installed with: pnpm dlx shadcn-svelte@latest add calendar-28 (unmodified)
	import Calendar28 from "$lib/components/calendar-28.svelte";
</script>

<main class="flex flex-col gap-4 p-8">
	<p>Type <code>June 01, 2025</code> into the input, then open the calendar: May 1, 2025 is selected.</p>
	<Calendar28 />
</main>
