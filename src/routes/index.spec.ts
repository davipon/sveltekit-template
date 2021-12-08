import { render } from '@testing-library/svelte'
import index from './index.svelte'

test('render index', () => {
	const { getByText } = render(index)
	expect(getByText('Welcome to SvelteKit')).toBeInTheDocument
})
