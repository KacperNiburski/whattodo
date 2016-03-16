
var Home =  React.createClass({
  
  render () {
    return (
      <div>
        <AppBar
          title="Title"
          iconClassNameRight="muidocs-icon-navigation-expand-more"
        />
      
        Question 1
        Question 2
        Question 3
        Result
        (Toggle importance, see scores change)
        Again
        <Question text="How much?" />
        <Question text="How far?" />
        <Question text="Feeling?" />

      </div>
    );
  }
})
