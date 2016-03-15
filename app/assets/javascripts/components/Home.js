var Home = React.createClass({
  render: function() {
    return (
      <div>
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
    )
    
  }
})