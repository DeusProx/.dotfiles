import { type Icons } from './iconlist'

type IconCtx = { name: Icons }
export function Icon(ctx: IconCtx) {
  return <image iconName={ctx.name}/>
}

