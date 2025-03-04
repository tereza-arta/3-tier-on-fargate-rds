import { useState, useEffect, useCallback } from "react";  // Ensure all hooks are imported
import axios from "axios";  // Make sure axios is imported
import "./MainComponent.css";

const MainComponent = () => {
  const [values, setValues] = useState([]);
  const [value, setValue] = useState("");

  // Use useCallback inside the component function
  const getAllNumbers = useCallback(async () => {
    try {
      const response = await axios.get(`http://${process.env.REACT_APP_API_URL}/api/values/all`);
      //const response = await axios.get(`http://Custom-lb-0-383338179.eu-north-1.elb.amazonaws.com/api/values/all`);
      setValues(response.data.map(row => row.number)); // Match backend response format
    } catch (error) {
      console.error("Error fetching numbers:", error);
    }
  }, []);

  const saveNumber = useCallback(
    async (event) => {
      event.preventDefault();
      try {
        await axios.post(`http://${process.env.REACT_APP_API_URL}/api/values`, {
        //await axios.post(`http://Custom-lb-0-383338179.eu-north-1.elb.amazonaws.com/api/values`, {
          value,
        });
        setValue("");  // Clear the input after saving
        getAllNumbers();  // Fetch updated list of numbers
      } catch (error) {
        console.error("Error saving number:", error);
      }
    },
    [value, getAllNumbers]
  );

  // Fetch all numbers on component mount
  useEffect(() => {
    getAllNumbers();
  }, [getAllNumbers]);

  return (
    <div>
      <button onClick={getAllNumbers}>Get all numbers</button>
      <br />
      <span className="title">Values</span>
      <div className="values">
        {values.map((value, index) => (
          <div key={index} className="value">{value}</div>
        ))}
      </div>
      <form className="form" onSubmit={saveNumber}>
        <label>Enter your value: </label>
        <input
          value={value}
          onChange={(event) => {
            setValue(event.target.value);
          }}
        />
        <button>Submit</button>
      </form>
    </div>
  );
};

export default MainComponent;

