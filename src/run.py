# -----------------------------------------------------------------------------
# ZENML SAMPLE PIPELINE (Stretch Goal A)
# -----------------------------------------------------------------------------
#
# This pipeline is used to validate your AWS stack setup (Stretch Goal A).
# If you complete the stretch goal, run this pipeline to prove your stack works.
#
# Prerequisites:
# - ZenML server deployed and accessible
# - AWS stack provisioned via Terraform (S3, ECR, Kubernetes orchestrator)
# - Logged in: `zenml login <your-server-url>`
# - Stack set: `zenml stack set <your-stack-name>`
#


import logging

from zenml import pipeline, step


@step
def loader() -> str:
    """A simple step that returns a string."""
    logging.info("Loading data...")
    return "Hello from the Cloud!"


@step
def processor(data: str) -> str:
    """A simple step that processes data."""
    logging.info(f"Processing data: {data}")
    return data.upper()


@step
def validator(processed_data: str) -> bool:
    """A simple step that validates the processed data."""
    logging.info(f"Validating data: {processed_data}")
    is_valid = len(processed_data) > 0
    logging.info(f"Data is valid: {is_valid}")
    return is_valid


@pipeline
def test_pipeline():
    """The pipeline that connects the steps."""
    data = loader()
    processed = processor(data)
    validator(processed)


if __name__ == "__main__":
    # This is for Stretch Goal A only.
    #
    # Before running:
    # 1. Deploy ZenML server (main challenge)
    # 2. Provision AWS stack with Terraform (stretch goal A)
    # 3. zenml login <your-server-url>
    # 4. zenml stack set <your-stack-name>
    # 5. python src/run.py
    test_pipeline()