import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";

import Button from "../UI/Button";
import ManDoor from "@/images/login.svg";
import Input from "../UI/Input";
import Select, { SelectOptions } from "../UI/Select";
import { useAppDispatch, useAppSelector } from "@/hooks/redux";
import { signupUser } from "@/store/actions/auth";
import { Gender } from "@/store/slices/auth-slice";
import { messageActions } from "@/store/slices/message-slice";

interface SignUpFormTypes {
  email: string;
  password: string;
  passwordConfirmation: string;
  firstName: string;
  lastName: string;
  gender: Gender;
  height: number;
  phone: string;
}

const defaultValues: SignUpFormTypes = {
  email: "",
  password: "",
  passwordConfirmation: "",
  firstName: "",
  lastName: "",
  gender: "male",
  height: 150,
  phone: "",
};

const genderOptions: SelectOptions[] = [
  { id: 1, label: "Homme", value: "male" },
  { id: 2, label: "Femme", value: "female" },
  { id: 3, label: "Non-binaire", value: "non-binary" },
];

const Signup = () => {
  const dispatch = useAppDispatch();
  const { message: error } = useAppSelector(state => state.message);
  const [formValues, setFormValues] = useState<SignUpFormTypes>(defaultValues);

  const isPasswordValid =
    formValues.password === formValues.passwordConfirmation &&
    formValues.password.length >= 6;
  const areMinCharsValid =
    formValues.firstName.length >= 3 &&
    formValues.lastName.length >= 2 &&
    formValues.phone.length >= 10;
  const isHeightValid = formValues.height >= 100 && formValues.height <= 200;
  const isValid = isPasswordValid && areMinCharsValid && isHeightValid;

  useEffect(() => {
    dispatch(messageActions.clearMessage());

    return () => { dispatch(messageActions.clearMessage()) };
  }, [dispatch])

  const handleInputChange = (
    e:
      | React.ChangeEvent<HTMLInputElement>
      | React.ChangeEvent<HTMLSelectElement>
  ) => {
    const { name, value } = e.target;

    setFormValues((prevValues) => {
      return {
        ...prevValues,
        [name]: value,
      };
    });
  };

  const handleForm = async (event: React.FormEvent) => {
    event.preventDefault();

    const formParams = {
      user: {
        first_name: formValues.firstName,
        last_name: formValues.lastName,
        email: formValues.email,
        gender: formValues.gender,
        height: formValues.height,
        phone: formValues.phone,
        password: formValues.password,
      },
    };

    dispatch(signupUser(formParams));
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
            required={true}
          />
          <Input
            id="lastName"
            type="text"
            label="Nom de famille"
            name="lastName"
            placeholder="Poulidor"
            value={formValues.lastName}
            onChange={handleInputChange}
            required={true}
          />
          <Select
            id="gender"
            name="gender"
            label="Genre"
            options={genderOptions}
            value={formValues.gender}
            onChange={handleInputChange}
            required={true}
          />
          <Input
            id="height"
            type="number"
            label="Taille (en cm)"
            name="height"
            min="100"
            max="200"
            value={formValues.height}
            onChange={handleInputChange}
            required={true}
          />
          <Input
            id="email"
            type="text"
            label="Email"
            name="email"
            value={formValues.email}
            onChange={handleInputChange}
            placeholder="raymond@cyckle.com"
            required={true}
          />
          <Input
            id="phone"
            type="tel"
            label="Numéro de téléphone"
            name="phone"
            value={formValues.phone}
            onChange={handleInputChange}
            placeholder="06 01 02 03 04"
            required={true}
          />
          <Input
            id="password"
            type="password"
            label="Mot de passe"
            name="password"
            placeholder="******"
            value={formValues.password}
            onChange={handleInputChange}
            required={true}
          />
          <Input
            id="passwordConfirmation"
            type="password"
            label="Confirmation du mot de passe"
            name="passwordConfirmation"
            placeholder="******"
            value={formValues.passwordConfirmation}
            onChange={handleInputChange}
            required={true}
          />
          {error && <p className="text-red-500">{error}</p>}
          <div className="flex flex-col items-center justify-center gap-4">
            <Button color="primary" className="mt-5" disabled={!isValid}>
              S'inscrire
            </Button>
            <p>
              Vous avez déjà un compte ? <Link to="/login">Identifiez-vous</Link>
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
