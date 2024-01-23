import { TextUiProps } from '../../../typings';
import { debugData } from '../../../utils/debugData';

export const debugTextUI = () => {
  debugData<TextUiProps>([
    {
      action: 'textUi',
      data: {
        text: '<span class="key">E</span> Open Store',
        position: 'left-center',
      },
    },
  ]);
};
