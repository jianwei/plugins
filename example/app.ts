import { InitialState } from 'umi';
import { MenuItem } from '@umijs/plugin-layout';
export function render(oldRender: Function) {
  oldRender();
}

export function getInitialState() {
  return {
    name: 'test',
  };
}

export const layout = {
  logout: () => {
    alert('退出登陆成功');
  },
  patchMenus: (menus: MenuItem[], initialInfo: InitialState) => {
    if (initialInfo?.initialState?.name === 'test') {
      return [
        ...menus,
        {
          name: '自定义',
          path: 'https://bigfish.alipay.com/',
        },
      ];
    }
    return menus;
  },
};

export const locale = {
  default: 'zh-CN',
};
