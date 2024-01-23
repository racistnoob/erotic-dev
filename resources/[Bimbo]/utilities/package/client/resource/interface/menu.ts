import { IconName, IconPrefix } from '@fortawesome/fontawesome-common-types';

type MenuPosition = 'top-left' | 'top-right' | 'bottom-left' | 'bottom-right';
type ChangeFunction = (selected: number, scrollIndex?: number, args?: any, checked?: boolean) => void;

interface MenuOptions {
  label: string;
  icon?: IconName | [IconPrefix, IconName] | string;
  checked?: boolean;
  values?: Array<string | { label: string; description: string }>;
  description?: string;
  defaultIndex?: number;
  args?: Record<any, any>;
  close?: boolean;
}

interface MenuProps {
  id: string;
  title: string;
  options: MenuOptions[];
  position?: MenuPosition;
  disableInput?: boolean;
  canClose?: boolean;
  onClose?: (keyPressed?: 'Escape' | 'Backspace') => void;
  onSelected?: ChangeFunction;
  onSideScroll?: ChangeFunction;
  onChecked?: ChangeFunction;
  cb?: ChangeFunction;
}

type registerMenu = (data: MenuProps, cb: ChangeFunction) => void;
export const registerMenu: registerMenu = (data, cb) => exports.utilities.registerMenu(data, cb);

export const showMenu = (id: string): string => exports.utilities.showMenu(id);

export const hideMenu = (onExit: boolean): void => exports.utilities.hideMenu(onExit);

export const getOpenMenu = (): string | null => exports.utilities.getOpenMenu();

type setMenuOptions = (id: string, options: MenuOptions | MenuOptions[], index?: number) => void;
export const setMenuOptions: setMenuOptions = (id, options, index) => exports.utilities.setMenuOptions(id, options, index);
