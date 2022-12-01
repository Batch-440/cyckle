import React, { useState } from "react";
import { Link } from "react-router-dom";

import Button from "../UI/Button";
import ManDoor from "@/images/login.svg";
import Input from "../UI/Input";
import Select, { SelectOptions } from "../UI/Select";

interface SignUpFormTypes {
  email: string;
  password: string;
  passwordConfirmation: string;
  firstName: string;
  lastName: string;
  gender: string;
  height: number;
  street: string;
  postalCode: string;
  city: string;
  phone: string;
}

const Signup = () => {
  const defaultValues: SignUpFormTypes = {
    email: "",
    password: "",
    passwordConfirmation: "",
    firstName: "",
    lastName: "",
    gender: "male",
    height: 150,
    street: "",
    postalCode: "",
    city: "",
    phone: ""
  };

  const genderOptions: SelectOptions[] = [
    { id: 1, label: "Homme", value: "male" },
    { id: 2, label: "Femme", value: "female" },
    { id: 3, label: "Non-binaire", value: "non-binary" }
  ]

  const [formValues, setFormValues] = useState<SignUpFormTypes>(defaultValues);

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement> | React.ChangeEvent<HTMLSelectElement>) => {
    const { name, value } = e.target;
    
    setFormValues(prevValues => {
      return {
        ...prevValues,
        [name]: value
      }
    });
  };


  const handleForm = (event: React.FormEvent) => {
    event.preventDefault();

    console.log(formValues);
  };

  return (
    <>
      <h1>Inscrivez-vous</h1>
      <div className="flex flex-col sm:flex-row items-center justify-between gap-4">
        <form onSubmit={handleForm} className="w-full sm:w-1/2">
          <Input
            id="firstName"
            type="text"
            label="Prénom"
            name="firstName"
            placeholder="Raymond"
            value={formValues.firstName}
            onChange={handleInputChange}
          />
          <Input
            id="lastName"
            type="text"
            label="Nom de famille"
            name="lastName"
            placeholder="Poulidor"
            value={formValues.lastName}
            onChange={handleInputChange}
          />
          <Select id="gender" name="gender" label="Genre" options={genderOptions} value={formValues.gender} onChange={handleInputChange} />
          <Input
            id="height"
            type="number"
            label="Taille (en cm)"
            name="height"
            placeholder="180"
            value={formValues.height}
            onChange={handleInputChange}
          />
          <Input
            id="email"
            type="text"
            label="Email"
            name="email"
            value={formValues.email}
            onChange={handleInputChange}
            placeholder="raymond@cyckle.com"
          />
          <Input
            id="password"
            type="password"
            label="Mot de passe"
            name="password"
            placeholder="******"
            value={formValues.password}
            onChange={handleInputChange}
          />
          <Input
            id="passwordConfirmation"
            type="password"
            label="Confirmation du mot de passe"
            name="passwordConfirmation"
            placeholder="******"
            value={formValues.passwordConfirmation}
            onChange={handleInputChange}
          />
          <div className="flex flex-col items-center justify-center gap-4">
            <Button color="primary" className="mt-5">
              S'inscrire
            </Button>
            <p>
              Vous avez déjà un compte ? <Link to="#">Identifiez-vous</Link>
            </p>
          </div>
        </form>
        <img
          src={ManDoor}
          alt="A man opening a door."
          className="w-full sm:w-1/2"
        />
      </div>
    </>
  );
};

export default Signup;
