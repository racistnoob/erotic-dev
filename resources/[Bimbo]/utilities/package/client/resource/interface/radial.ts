import { IconName, IconPrefix } from '@fortawesome/fontawesome-common-types';

type RadialItem = {
  id: string;
  label: string;
  icon: IconName | [IconPrefix, IconName];
  onSelect?: (currentMenu: string | null, itemIndex: number) => void | string;
  menu?: string;
};

export const addRadialItem = (items: RadialItem | RadialItem[]) => exports.utilities.addRadialItem(items);

export const removeRadialItem = (item: string) => exports.utilities.removeRadialItem(item);

export const registerRadial = (radial: { id: string; items: Omit<RadialItem, 'id'>[] }) =>
  exports.utilities.registerRadial(radial);

export const getCurrentRadialId = () => exports.utilities.getCurrentRadialId();

export const hideRadial = () => exports.utilities.hideRadial();

export const disableRadial = (state: boolean) => exports.utilities.disableRadial(state);
