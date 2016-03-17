const Bar = () => (
  <AppBar
    title="Title"
    iconElementLeft={<IconButton></IconButton>}
    iconElementRight={
      <IconMenu
        iconButtonElement={
          <IconButton><MoreVertIcon /></IconButton>
        }
        targetOrigin={{horizontal: 'right', vertical: 'top'}}
        anchorOrigin={{horizontal: 'right', vertical: 'top'}}
      >
        <MenuItem primaryText="Question 1" />
        <MenuItem primaryText="Question 2" />
        <MenuItem primaryText="Question 3" />
        <MenuItem primaryText="Result with Toggle" />
        <MenuItem primaryText="Again" />
      </IconMenu>
    }
  />
);