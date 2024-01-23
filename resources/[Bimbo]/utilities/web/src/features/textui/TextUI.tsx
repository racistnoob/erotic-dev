import React from 'react';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import { Box, createStyles, Group } from '@mantine/core';
import ReactMarkdown from 'react-markdown';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import ScaleFade from '../../transitions/ScaleFade';
import remarkGfm from 'remark-gfm';
import type { TextUiProps, TextUiPosition } from '../../typings';

import '../../index.css'

const useStyles = createStyles((theme, params: { position?: TextUiPosition }) => ({
  wrapper: {
    height: '100%',
    width: '100%',
    position: 'absolute',
    display: 'flex',
    alignItems: params.position === 'top-center' ? 'baseline' : 'center',
    justifyContent:
      params.position === 'right-center' ? 'flex-end' : params.position === 'left-center' ? 'flex-start' : 'center',
  },
  container: {
    fontSize: 14,
    padding: 12,
    margin: 8,
    backgroundColor: 'rgba(0, 0, 0, 0.75)',
    color: theme.colors.dark[0],
    fontFamily: 'Poppins',
    borderRadius: '7px',
    boxShadow: theme.shadows.sm,
  },
  content: {
    fontFamily: 'Poppins',
    color: 'white',
    fontWeight: 600
  }
}));

const TextUI: React.FC = () => {
  const [data, setData] = React.useState<TextUiProps>({
    text: '',
    position: 'left-center',
  });
  const [visible, setVisible] = React.useState(false);
  const { classes } = useStyles({ position: data.position });

  useNuiEvent<TextUiProps>('textUi', (data) => {
    if (!data.position) data.position = 'left-center'; // Default right position
    setData(data);
    setVisible(true);
  });

  useNuiEvent('textUiHide', () => setVisible(false));

  return (
    <>
      <Box className={classes.wrapper}>
        <ScaleFade visible={visible}>
          <Box style={data.style} className={classes.container}>
            <Group spacing={12}>
              {data.icon && <FontAwesomeIcon icon={data.icon} fixedWidth size="lg" style={{ color: data.iconColor }} />}
              <Box className={classes.content} dangerouslySetInnerHTML={{ __html: data.text }}></Box>
            </Group>
          </Box>
        </ScaleFade>
      </Box>
    </>
  );
};

export default TextUI;
