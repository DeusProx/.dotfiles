import { Accessor } from 'gnim'
import { type Icons } from './iconlist'

type IconCtx = { name: Icons | string | Accessor<Icons | string> }
export function Icon(ctx: IconCtx) {
  return <image iconName={ctx.name}/>
}

