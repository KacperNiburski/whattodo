class CardModule extends React.Component {
  constructor() {
    super()
    this.state = {
      email: ""
    }
  }

  render() {
    return (
      <TextField hintText={this.state.email || "Email"}  />  
    );
  }
};