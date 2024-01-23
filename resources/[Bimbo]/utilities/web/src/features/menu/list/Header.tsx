import { Box, createStyles, Text } from '@mantine/core';
import React from 'react';

const useStyles = createStyles((theme) => ({
  container: {
    textAlign: 'center',
    borderTopLeftRadius: 3,
    borderTopRightRadius: 3,
    background: 'linear-gradient(180deg, rgba(0, 0, 0, 0.80) 0%, rgba(0, 0, 0, 0.79) 25%, rgba(0, 0, 0, 0.78) 71.95%, rgba(0, 0, 0, 0.75) 100%)',
    height: 120,
    width: 384,
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
  },
  heading: {
    display: 'flex',
    alignItems: 'end',
    justifyContent: 'center',

    width: '100%',
    height: '100%',

    fontSize: 16,
    fontWeight: 700,
    marginTop: '.1vw',

    fontFamily: 'Inter',
    gap: '.2vw',

    '& span': {
      color: 'rgba(255, 255, 255, 0.66)',
      fontSize: 14
    }
  },
  image: {
    marginBottom: '.75vw',
    position: 'absolute',
    backgroundRepeat: 'no-repeat',
    backgroundSize: 'contain',
    backgroundPosition: 'center',
    width: 180,
    height: '100%',
  }
}));

const Header: React.FC<{ title: string }> = ({ title }) => {
  const { classes } = useStyles();

  return (
    <Box className={classes.container}>
      {/* <Box className={classes.image}></Box> */}
      <Text className={classes.heading}>Erotic PVP <span>|</span> Menu</Text>
    </Box>
  );
};

export default React.memo(Header);
